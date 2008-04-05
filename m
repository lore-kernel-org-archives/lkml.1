Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbYDECHb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbYDECHb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 22:07:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYDECHV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 22:07:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:55004 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbYDECHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 22:07:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=SoTYH5hYU9eyukDmWnhkXiVSCkTKiLj0uG/wqa0GDlmPffpP7C4ugKkPf44ToST/Crr6usei9mJc0GBju0KiVgRyiJ6vB4gN4cPbO36eCJJmzfKdQqGi4kgMnnHREOtJzcb0vnTpukIRL9uDTzZtDgiHtzVtv4DOqJMxsni5Ql4=
Message-ID: <47F6DEBA.4000500@gmail.com>
Date: Fri, 04 Apr 2008 21:06:50 -0500
From: Roger Heflin <rogerheflin@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: devzero@web.de
CC: dan.hecht@vmware.com, johnstul@us.ibm.com, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org
Subject: Re: Clock has stopped (time/date looping over 5 seconds), things
 are
References: <226243507@web.de>
In-Reply-To: <226243507@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devzero@web.de wrote:
> so, this happens on real hardware for you?
> 
> i could reproduce this with a linux virtual machine on vmware - whenever i suspended the windows host with a linux vm running in vmware, after resume the linux vm showed exactly this issue.
> after some investigation i found, that it would recover from that state after some time - and the time needed for recover was (more or less) proportional to that time the host was in suspend(hibernate) state.
> 
> also see http://marc.info/?l=linux-kernel&m=120186717701371&w=2
> 
> i thought that was vmware related and i gave a bug report to dan hecht - i didn`t hear anything since then, but i think it`s worth CC`ing him.
> 
> not sure if 
> [PATCH 1/2] Introduce clocksource_forward_now -> http://marc.info/?l=linux-kernel&m=120716471203567&w=2
> [PATCH 2/2] Introduce CLOCK_MONOTONIC_RAW -> http://marc.info/?l=linux-kernel&m=120596518521892&w=2 
> is related ? (also CC`d the patch authors, they will probably know)
> 
> regards
> roland
> 
> 

This is real hardware, it is a always on desktop MB machine, nothing too weird, 
right now I am putting 2.6.24.4 on it, and we will see in a few weeks if it does 
it again.

I am getting it fairly consistently, so any ideas of what to turn on, or watch 
for in the next event would be useful.    I did try collect several samples of 
information from /proc of things that looked useful, the most telling thing I 
found was that it appeared that in /proc/timer_list

now at 7300171087468 nsecs (number was different).

was actually looping similar to the time/date and not rising as it should have 
been, this is a 32 bit on an AMD Sempron(tm) Processor 3400+, it is 64bit 
capable. I did have files that containing several samples of /proc/timer_list, 
but apparently the alt-sysrq-s then u before the b failed to save the 
information or the general state of the machine was just so bad that it did not 
get written out to disk, the last 2 times I have had this happen, it completely 
failed to shutdown gracefully and s-u-b at least enabled me to force a reboot 
without having to go to the machine and power cycle it.

 From previous data, the shortest time is 14 days 11 hours, and the longest is 
about 23 days.


                                Roger




