Return-Path: <linux-kernel-owner+w=401wt.eu-S1757255AbYHUR7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757255AbYHUR7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYHUR7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:59:12 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:33784 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861AbYHUR7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:59:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oNerCkmvMWsN+przu5SwA7nfciRun2yukV29M88WWh8DTB/idAKusNJJYXP2vnCB3c
         MWU7vVlADxxxrV4KYyJ3VPuEqHdqo/zmmW3K6J5GsvZmVctAuUpaUY86HhOWeReQCR7F
         hR/b75zBNzUkEHZ60PEkOp1jjvOXm/naGp1fM=
Message-ID: <19f34abd0808211059m451f5f7au949217aeecccccaf@mail.gmail.com>
Date: Thu, 21 Aug 2008 19:59:10 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: latest -git: hibernate: possible circular locking dependency detected
Cc: "Oleg Nesterov" <oleg@tv-sign.ru>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Max Krasnyanskiy" <maxk@qualcomm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808210804y7ee91d1fy12da5ad6f82d2451@mail.gmail.com>
	 <b647ffbd0808211038h686f9df3ud335efbc46242952@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 7:38 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
>> [ INFO: possible circular locking dependency detected ]
>> 2.6.27-rc4-00003-ga798564 #28

[...]

> this path is triggered as a result of "echo disk > /sys/power/state"

Yes. That is what I typed.

>
> disable_nonboot_cpus() calls cpu_maps_update_being() which takes
> "cpu_add_remove_lock" (lock-1).
>
> If we go down the road cleanup_workqueue_thread() ->
> flush_cpu_workqueue() will take "cwq->lock" (lock-2).
> So this should be the second lock.
>
>
[...]

> hmm, did you somehow hit "Sysrq + o"?
>
> 'cause I don't see any other places (say, with handle_sysrq(k,...)
> where "k" migth be 'o') from where do_power_off() might have been
> triggered...
>

No. But in my logs I often saw SysRq triggered, even though I didn't
do it any of these times:

log-20080821-104053.txt:SysRq : SysRq : Show State
log-20080821-105541.txt:SysRq : Emergency Sync
log-20080821-105541.txt:SysRq : Emergency Sync
log-20080821-105541.txt:SysRq : Power Off
log-20080821-110514.txt:SysRq : Terminate All Tasks
log-20080821-111650.txt:SysRq : HELP : loglevel0-8 <6>serial 00:0d: activated
log-20080821-111650.txt:SysRq : Power Off
log-20080821-111650.txt:SysRq : Terminate All Tasks
log-20080821-111650.txt:SysRq : SysRq : <6>serial 00:0d: activated
log-20080821-120628.txt:SysRq : SysRq : HELP : HELP : <6>serial 00:0d: activated
log-20080821-120628.txt:SysRq : SysRq : HELP : HELP : <6>serial 00:0d: activated

(And it seems to pick a random letter too. It even showed the "HELP:"
line at one point!)

I have no idea why this happens. Is it possible to trigger SysRq by
writing data on the other end of the serial console? (Maybe my cable
is bad or something, but data seems to be going in both directions
over my serial console.)

The rest I will not comment on. It also seems unlikely that I will be
able to test any patches reliably, simply because I see a few
different kinds of issues on resume :-(

Thanks!


Vegard


-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
