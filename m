Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZJLS0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZJLS0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbZJLS0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:26:02 -0400
Received: from smtprelay11.ispgateway.de ([80.67.31.34]:45773 "EHLO
	smtprelay11.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757472AbZJLS0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:26:01 -0400
Message-ID: <4AD37478.2070204@bwalle.de>
Date: Mon, 12 Oct 2009 20:24:56 +0200
From: Bernhard Walle <bernhard@bwalle.de>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linuxfoundation.org, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org
Subject: Re: [PATCH 5/5] Always print panic message on current console
References: <1255207870-24496-1-git-send-email-bernhard@bwalle.de>	<1255207870-24496-6-git-send-email-bernhard@bwalle.de> <87d44sh5uj.fsf@basil.nowhere.org>
In-Reply-To: <87d44sh5uj.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=DDAF6454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Df-Sender: 1227806
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen schrieb:
> Bernhard Walle <bernhard@bwalle.de> writes:
> 
>> The kernel offers with TIOCL_GETKMSGREDIRECT ioctl() the possibility to
>> redirect the kernel messages to a specific console.
>>
>> However, since it's not possible to switch to the kernel message console after
>> a panic(), it would be nice if the kernel would print the panic message on the
>> current console.
> 
> The basic idea is good, but you really need to call this in a lot
> more places, which print some addition needed information before the panic.
> The one liner panic is often not enough to decide what went wrong.
> Example are machine checks, oopses, probably more.
> 
> In general for the recent work to switch the video mode on panic
> we need a generalized hook for this anyways, so you could use
> some generalized function.

Is that video switch called in a panic notifier list or does that
introduce a new hook?

One problem is that kexec is executed before the panic notifier. Which
is okay for printk(), but it would be very good if the video switch
would occur before kexec.



Regards,
Bernhard

