Return-Path: <linux-kernel-owner+w=401wt.eu-S1754628Ab0AVKiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab0AVKiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431Ab0AVKiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:38:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:64429 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab0AVKiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:38:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a3bI8oPis2SyRudXPOms1gCP9XkdPaJGpaOW3o1i8NSdL7Obsp2Vz1DKX7TIJPG6Wy
         T3RL4XxrC0yu/tcJeCYWsUeNGXZJHSGSdVtuMBTqOe3AN5rdj6PugW8ojB3RyXOLHpA7
         Bg51OBqzGsypJtyC+dmXRLQdOiGNAiiunHKh4=
MIME-Version: 1.0
In-Reply-To: <48239d391001210932w5523cc4ajc3b5459966ab395e@mail.gmail.com>
References: <48239d391001210326y25986d59hd10d390ef9c8ddea@mail.gmail.com>
	 <20100121122839.GB26015@nokia.com>
	 <48239d391001210523l5762775dm8382ad82e7b10e4a@mail.gmail.com>
	 <48239d391001210816n7dd469acr920be41e98129cb4@mail.gmail.com>
	 <20100121162437.GC3628@gandalf>
	 <48239d391001210932w5523cc4ajc3b5459966ab395e@mail.gmail.com>
Date: Fri, 22 Jan 2010 13:38:19 +0300
Message-ID: <48239d391001220238r151c4dfbjd8f6e7863718dad8@mail.gmail.com>
Subject: Re: MUSB crash on OMAP3 board with second load of gadget
From: Sergey Lapin <slapinid@gmail.com>
To: me@felipebalbi.com
Cc: felipe.balbi@nokia.com,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> [  580.082427] [<c0030ac4>] (__irq_svc+0x44/0xa8) from [<c00420dc>]
> (omap3_enter_idle+0x124/0x158)
> [  580.091186] [<c00420dc>] (omap3_enter_idle+0x124/0x158) from
> [<c022d708>] (cpuidle_idle_call+0xa4/0x180)
> [  580.100738] [<c022d708>] (cpuidle_idle_call+0xa4/0x180) from
> [<c00324dc>] (cpu_idle+0x48/0x98)
> [  580.109436] [<c00324dc>] (cpu_idle+0x48/0x98) from [<c0008934>]
> (start_kernel+0x268/0x2c8)
> [  580.117767] [<c0008934>] (start_kernel+0x268/0x2c8) from
> [<80008034>] (0x80008034)
> [  580.125366] Code: c03a876b e92d4013 e5903004 e1a04000 (e593c000)
> [  580.131652] ---[ end trace 42b8f4f7e396999c ]---
> [  580.136291] Kernel panic - not syncing: Fatal exception in interrupt
>

I've managed to debug that in my case,
drivers/usb/musb/musb_gadget_ep0.c:
musb_read_setup():
        /* clean up any leftover transfers */
        r = next_ep0_request(musb);
in this place we have somewhat corrupted usb_request. Any ideas why?

By the way, crash is not reproduced if cable is removed before module unloading
(and all USB activity processed).

S.
