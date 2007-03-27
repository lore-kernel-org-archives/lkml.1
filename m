Return-Path: <linux-kernel-owner+w=401wt.eu-S965414AbXC0UlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414AbXC0UlG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965417AbXC0UlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:41:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:27143 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965416AbXC0UlD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=av07FTEvt04kHNk3n0Ynh7cSUXeiiwqZb7bWT8migcNmAZgU2inqsJIIDv1s+sxS9QafrXWQ2FTXTPO+JhFGklPUDojZ29jdSdGpEp7OWLK7bCeaFhSf9Yp7V+UX2Y+pd4p1L7ZiaciPOzU3H1d6Nk8SF/Xi5BF2bfzSQcKgtfo=
Message-ID: <75b66ecd0703271341x34463c49w64bdac21a9741355@mail.gmail.com>
Date: Tue, 27 Mar 2007 16:41:01 -0400
From: "Lee Revell" <rlrevell@joe-job.com>
To: John <linux.kernel@free.fr>
Subject: Re: 2.6.20.3-rt8 - DMA suffers excessive delay periodically
Cc: linux-kernel@vger.kernel.org, tglx@timesys.com, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org, linux-apps@vger.kernel.org
In-Reply-To: <46094728.40300@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46094728.40300@free.fr>
X-Google-Sender-Auth: 090166f26b4f1be4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, John <linux.kernel@free.fr> wrote:
> I'm runnning 2.6.20.3 patched with -rt8 (and glibc 2.3.6).
> http://people.redhat.com/mingo/realtime-preempt/older/patch-2.6.20-rt8
>
> I've written a program to highlight a phenomenon I don't understand.
>
> This system includes a PCI board that provides data at ~38 Mbit/s.
> I request data in lumps of 1316 bytes.
> In other words, a new request should complete every 277 µs.
>
> However, if I time stamp each packet as soon as I receive it, I notice
> that almost exactly every 2 seconds, the packet is received 30-100
> microseconds late.

Sounds like periodic SMM traps.  There's not much you can do about
them other than to avoid such hardware if you have tight RT
constraints.  The RTAI people have some code to disable SMM but it
does not work on all chipsets and may render some of your hardware
inoperable.

Is this a laptop?  They are plagued with SMM problems...

Lee
