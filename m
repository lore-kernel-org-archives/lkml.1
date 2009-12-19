Return-Path: <linux-kernel-owner+w=401wt.eu-S1754341AbZLSDUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341AbZLSDUV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 22:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbZLSDUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 22:20:17 -0500
Received: from smtp107.biz.mail.mud.yahoo.com ([68.142.200.255]:31437 "HELO
	smtp107.biz.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751108AbZLSDUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 22:20:16 -0500
X-Yahoo-SMTP: qGLgp.mswBDSnFfWmYVMF5Rmg6NJ
X-YMail-OSG: GCuMpsUVM1krpYAQwmMFLSmhf3CDxc3jbuJVtRU2lcbiI4xWZprvum9rkGqgUUMrJtzdCiWXriImAtDbbgIXQZTSYUWAvPGfn0eBJZ2nQNq3tk4NZDEBUoijjtOWHZflK_JJceQyClmksD3WigL0.Gf0rlqr623jJ3XMdpFsRodo20mq7tBmYP0ziYizp1_pCnQYuMHCEelfA_NnYrW.cGTEKH45PaU_Wd3Xj4A6N5UozsbwsvtyGYIyP0sYBYtieTYYw5Vcts1PaUnOOH5gPfWzP4.BxhM7c46hsk5vYVBNMpS.zZw.nm3Lmb68V84VEkozej6JWtZvxpkkf6P5RoR8B9xuDohAwXjtWoCFJm0tzHIG.HmluvdNrdoJsnpCWXcTGtks
X-Yahoo-Newman-Property: ymail-3
From: Steven King <sfking@fdwdc.com>
Organization: fdwdc.com
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.33-rc1: hrtimers and tickless broken on m68knommu.
Date: Fri, 18 Dec 2009 19:20:12 -0800
User-Agent: KMail/1.9.9
Cc: john stultz <johnstul@us.ibm.com>
References: <200912181813.44220.sfking@fdwdc.com> <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>
In-Reply-To: <1f1b08da0912181844u4f7e66a7ue30287208d075327@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912181920.12905.sfking@fdwdc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 December 2009 06:44:44 john stultz wrote:
> On Fri, Dec 18, 2009 at 6:13 PM, Steven King <sfking@fdwdc.com> wrote:
> > Attach is the .config; it works on v2.6.32 but fails to boot on .33-rc1;
> > but if I deselect hrtimers && tickless then it works.
>
> Sorry for the dup, forgot to cc lkml on my reply.
>
> Fails to boot all together? Or does it hang at some point in the dmesg
> that you can point out?

fails to boot all together; nothing on the serial console.
>
> Could you run the following so we can narrow down which clocksource your
> using? cat /sys/devices/system/clocksource/clocksource0/current_clocksource
> cat /sys/devices/system/clocksource/clocksource0/available_clocksource
>
> Then with the kernel that doesn't boot, go through the clocksources
> listed in available_clocksources and try booting w/
> "clocksource=<clock name>" and see if the behavior changes.

on the working .32 kernel:

# cat /sys/devices/system/clocksource/clocksource0/current_clocksource
pit
# cat /sys/devices/system/clocksource/clocksource0/available_clocksource
pit

just to be sure, I tried clocksource=pit on the .33-rc1 kernel.  It didnt make 
any difference.

-- 
Steven King -- sfking at fdwdc dot com
