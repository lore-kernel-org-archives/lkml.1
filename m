Return-Path: <linux-kernel-owner+w=401wt.eu-S932431AbXDAKx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbXDAKx7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 06:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932433AbXDAKx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 06:53:59 -0400
Received: from fmmailgate09.web.de ([217.72.192.184]:42125 "EHLO
	fmmailgate09.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431AbXDAKx6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 06:53:58 -0400
Date: Sun, 01 Apr 2007 12:53:55 +0200
Message-Id: <1713627366@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: linux-kernel@vger.kernel.org
Cc: jdike@addtoit.com
Subject: Re: [patch] remove artificial software max_loop limit 
Organization: http://freemail.web.de/
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

not sure if this is a real issue and if it`s UML or loop related -  but how is low-memory situations being handled when creating loop devices ?

should losetup or dmesg tell "out of memory" if there is not enough memory left ?

i fired up my 2.6.20 UML and tried to create lots of loop-devices.

this crashed my UML very soon , just around 200 devices - then i saw my "mistake" that my UML had only 32MB of RAM.

then i gave my UML mem=256M and now i can setup many more loop-devices, but still crashes in the end:

setting up loop-device 1962 with losetup
Kernel panic - not syncing: do_fork failed in kernel_thread, errno = -11

EIP: 0073:[<ffffe410>] CPU: 0 Not tainted ESP: 007b:b7e6ffb0 EFLAGS: 00000246
    Not tainted
EAX: 00000000 EBX: 000072b3 ECX: 00000013 EDX: 000072b3
ESI: 000072af EDI: 00000011 EBP: 00000000 DS: 007b ES: 007b
087e7eac:  [<0807ca7b>] notifier_call_chain+0x1d/0x33
087e7ec8:  [<08071416>] panic+0x52/0xdd
087e7ee4:  [<0805cd74>] kernel_thread+0x5d/0x5f
087e7ef4:  [<0808217f>] keventd_create_kthread+0x1a/0x48
087e7ef8:  [<080820cb>] kthread+0x0/0x9a
087e7f10:  [<0807f5fb>] run_workqueue+0x8a/0x11f
087e7f18:  [<08082165>] keventd_create_kthread+0x0/0x48
087e7f1c:  [<08068351>] set_signals+0x1d/0x32
087e7f2c:  [<0807f690>] worker_thread+0x0/0x14e
087e7f30:  [<0807f7a1>] worker_thread+0x111/0x14e
087e7f74:  [<0806e771>] default_wake_function+0x0/0x12
087e7f98:  [<0808213f>] kthread+0x74/0x9a
087e7fbc:  [<080679bf>] run_kernel_thread+0x38/0x41
087e7fd8:  [<080679a2>] run_kernel_thread+0x1b/0x41
087e7fe4:  [<0805f92f>] new_thread_handler+0x53/0x79
087e7fe8:  [<080820cb>] kthread+0x0/0x9a


regards
roland






> -----Ursprüngliche Nachricht-----
> Von: devzero@web.de
> Gesendet: 01.04.07 11:16:14
> An: linux-kernel@vger.kernel.org
> Betreff: Re: [patch] remove artificial software max_loop limit 


> >Remove artificial maximum 256 loop device that can be created due to a
> >legacy device number limit.  Searching through lkml archive, there are
> >several instances where users complained about the artificial limit
> >that the loop driver impose.  There is no reason to have such limit.
> 
> Hey, i was one of those :)
> 
> Nice to see, that it`s solved now, thanks very much!
> 
> I never expected this to happen and put all my hope into dm-loop instead.
> Did you mind that Bryn m. Reeves from redhat will suffer a serious depression now? ( ->  http://sources.redhat.com/lvm2/wiki/DMLoop ) ;)
> 
> regards
> roland
> 


_______________________________________________________________
SMS schreiben mit WEB.DE FreeMail - einfach, schnell und
kostenguenstig. Jetzt gleich testen! http://f.web.de/?mc=021192

