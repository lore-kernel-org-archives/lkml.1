Return-Path: <linux-kernel-owner+w=401wt.eu-S1754236AbXD1Vxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236AbXD1Vxr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 17:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbXD1Vxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 17:53:47 -0400
Received: from smtp2-g19.free.fr ([212.27.42.28]:34359 "EHLO smtp2-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754198AbXD1Vxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 17:53:46 -0400
Message-ID: <4633C269.9050806@free.fr>
Date: Sat, 28 Apr 2007 23:53:45 +0200
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070217 Iceape/1.1.1 (Debian-1.1.1-2)
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: High Resolution Timer DOS
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

some programs need to do some short of busyloop. It was often 
implemented as :

while (1) {
	if (can_do_stuff) {
		do_stuff();
	}
	else
		//sleep a very short of time
		usleep(1);
}

usleep(1) or equivalent where used instead of sched_yield, because of 
some priority issue. IIRC doing sched_yield, make the process appears 
like an interactive process, so it has better priority and get call more 
often.

But now if high res timer are enabled, these programs while cause 
something like a DOS : the context switch per second will be bigger than 
500 000 and the cpu usage will be very high.


I don't know if such problem are already know, but I believe a warning 
about such issues should be in the Kconfig description.


Matthieu
