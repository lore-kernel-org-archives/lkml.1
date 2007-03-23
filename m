Return-Path: <linux-kernel-owner+w=401wt.eu-S1751673AbXCWE4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673AbXCWE4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 00:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422672AbXCWE4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 00:56:10 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:15056 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbXCWE4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 00:56:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=kI61RqnLqdheKU15GgSO9dZ6p/2gtCXy18iz1ovXOeQSkjgPFT45dorxl4RNBvVKaYoLmn82QpE2fdew9Z2OZj2ghLyy1dV82fhX+YN4yux+IW/u2Wa8Bo2LzsEd1EqxF3HFXjzqxiJpgS3nRH9joAwEdjb45B6JQ3aocyKMRGg=
Message-ID: <12c511ca0703222156u3cc09833rec636b47ad156029@mail.gmail.com>
Date: Thu, 22 Mar 2007 21:56:03 -0700
From: "Tony Luck" <tony.luck@intel.com>
To: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH][2/2] double stack limit (rfc)
Cc: "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
       "dmosberger@gmail.com" <dmosberger@gmail.com>,
       surinder.kumar@oracle.com, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070323122129.555a87fd.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070323122129.555a87fd.kamezawa.hiroyu@jp.fujitsu.com>
X-Google-Sender-Auth: 396c451602ce4494
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/22/07, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> I hear some people says that "When I set stack-size-limit to 32M,
> I want to use 32M of memory stack..." and register-stack expansion can
> fail because stack is used up by memory-stack.

An interesting dilemma.  If you apply this patch though, you might
get someone complain that they set the stack limit to 32M, but
execution continued as the program ran all the way to 64M!

Possibly you might argue that each of the memory stack and the
RBS stack should be allowed to grow to the stacklimit ... in which
case you'd need a more invasive patch that made separate vma
for each of the stack and the RBS stack, and checked at fault
time each would be allowed to grow to the stack limit.  But I'm
not sure that I like that ... ia64 happens to split different objects
in the stack between the RBS and the memory stack depending
on whether they happen to be allocated by the compiler to
stack registers (r32-r127) or to actual memory locations.  Both
types of allocation contribute to the total "stack" size of the
process so the existing behaivour of keeping the sum of the
size of the RBS stack and the memory stack below the
stack limit seems quite reasonable.  I'm willing to listen to
opposing arguments though.

-Tony
