Return-Path: <linux-kernel-owner+w=401wt.eu-S932760AbXFGQBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932760AbXFGQBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 12:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763704AbXFGQAZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 12:00:25 -0400
Received: from fallback.us4.outblaze.com ([205.158.62.120]:46641 "EHLO
	fallback.us4.outblaze.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765366AbXFGQAT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 12:00:19 -0400
X-OB-Received: from unknown (205.158.62.232)
  by wfilter.us4.outblaze.com; 7 Jun 2007 15:55:56 -0000
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
From: "Lauri Kasanen" <curaga@operamail.com>
To: linux-kernel@vger.kernel.org
Date: Thu, 7 Jun 2007 17:55:57 +0200
Subject: Kernel hang right before init on some i586 (bug report)
X-Originating-Ip: 88.192.212.116
X-Originating-Server: ws5-11.us4.outblaze.com
Message-Id: <20070607155557.58D96CA0A4@ws5-11.us4.outblaze.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Yesterday I encountered this bug, and after trying everything, thought
I'd let you know. I also googled a lot, and there is no known solution.
So now I tell my findings to the kernel developers.

On some i586 comps linux kernel hangs right after displaying "freeing unused 
kernel memory:". Here it's supposed to start init, but init never gets started.
On one site someone added debug statements to kernel's init.c and made /sbin/init a shell 
script echoing text. Guess what? kernel debug lines printed, that echo did not.

I've made a two-floppy linux system, it boots on every other comp but my old laptop.
After that kernel hang, I recompiled a few times, tried 2.6.16.52, 2.6.21.1 and 
2.6.16.21-ck2 with dynticks. Each had the bug. I also booted with every bootcode 
listed in kernel-parameters.txt as "BUGS=x86-32", and it still hung at that point.
This makes me believe there is no known solution.

Common points:

- always happens at some i586 systems. Mostly laptops, some desktops
- always hangs at the same point
- always prints no errors, and is not a total hang; boot messages can be scrolled
and ctrl-alt-del works
- has happened with both 2.4 and 2.6 series. No reports on 2.2 found on google..
- may be a bug in gcc, kernel or both
- they were mostly built on i686's, but not always
- the kernels were always configured for pentium-classic or lower. So they Should run..

One guy who also had this issue pressed sysrq-t at this bug and got 8 screenfuls of debug output.
Here: http://knierim.org/~justin/debug/

>From many hundred hits on google I found it hangs at execve() call for init.
I'm no programmer, but I think it may be gcc wrongly compiling that to need i686 code,
or a bug in kernel itself. But this doesn't affect all i586s. So go figure..

Here's also a long discussion about this bug:
http://wiki.linuxfromscratch.org/livecd/ticket/1638

My laptop is Toshiba Satellite 200cds. Pentium-classic with F00F bug and 40mb ram.


I hope I could help. Since I have the hardware where this bug occurs, I can test any patch you send me.
The list is very busy, so I haven't subscribed, so please CC me.

Lauri

PS: Linux rules!

-- 
_______________________________________________
Surf the Web in a faster, safer and easier way:
Download Opera 9 at http://www.opera.com

Powered by Outblaze
