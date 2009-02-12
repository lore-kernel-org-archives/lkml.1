Return-Path: <linux-kernel-owner+w=401wt.eu-S1761233AbZBLVyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761233AbZBLVyO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761082AbZBLVxz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:53:55 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43621 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760949AbZBLVxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:53:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=VTWSty4ZGx/gSQhfSJ2B1LAXbaSQQ90OH1eESm12YBYh9GKwaVj6R+FKGxwJm2/aB
	tm0Y6sxsW/FS4Bm2FThKg==
MIME-Version: 1.0
In-Reply-To: <4993DC9E.1090703@cn.fujitsu.com>
References: <4976D77C.3020107@cn.fujitsu.com>
	 <200902121154.02868.nickpiggin@yahoo.com.au>
	 <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
	 <200902121255.43047.nickpiggin@yahoo.com.au>
	 <4993DC9E.1090703@cn.fujitsu.com>
Date: Thu, 12 Feb 2009 13:53:48 -0800
Message-ID: <6599ad830902121353m6e30d573t3a854c989a49f6d5@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: miaox@cn.fujitsu.com
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 12:23 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
>
> In the extreme case, Task1 will be completely unable to allocate memory
> at worst. At least, it will lead to the delay of allocate pages. Though
> the probability of this case is very low, we have to take into account.

As Nick says, this is basically maliciousness on the part of
(privileged) Task2. I don't think it's a situation we need to even try
to deal with (other than not oopsing, and doing the right thing once
Task2 stops being an ass).

Paul
