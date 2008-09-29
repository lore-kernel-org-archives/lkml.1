Return-Path: <linux-kernel-owner+w=401wt.eu-S1753806AbYI2H1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbYI2H1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 03:27:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751939AbYI2H1c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 03:27:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:21178 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787AbYI2H1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 03:27:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:user-agent:mime-version:to:cc:subject:
	references:in-reply-to:content-type:content-transfer-encoding;
	b=VCvIGcFUIQaQK7dszwy/ura9te65nShPo7FmniwYEr7lwhO3KCwoL/Wmg/EIzaDxD
	37WWbNQV20bOlCIfn8nTA==
Message-ID: <48E0834D.6010608@google.com>
Date: Mon, 29 Sep 2008 00:27:09 -0700
From: dean gaudet <odo@google.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Pardo <pardo@google.com>, linux-kernel@vger.kernel.org, mbligh@google.com,
       briangrant@google.com, nil@google.com, jyasskin@google.com
Subject: Re: Faster getcpu() and sched_getcpu()
References: <af8810200809111648n55e05ac9g286fcd498690432f@mail.gmail.com>	<af8810200809231209w7428347neb88094e543a048f@mail.gmail.com> <87wsgwp6gh.fsf@basil.nowhere.org>
In-Reply-To: <87wsgwp6gh.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I'm still not sure why you say no redzone is that expensive? Do you
> have numbers?  I know it's a few instructions, but it shouldn't 
> be that expensive.
>
>   

it depends on the processor involved and the kernel config options --
i.e. if frame pointers are enabled then the stack frame guarantees a
store operation (push rbp) and on processors which do memops in-order
this delays the other memops in the vsyscall (i.e. testing the cache or
executing SIDT).  it was 2 or 3 cycles difference in most cases iirc.

-dean

