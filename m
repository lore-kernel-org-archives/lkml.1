Return-Path: <linux-kernel-owner+w=401wt.eu-S1754983Ab0AZTRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab0AZTRR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 14:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754329Ab0AZTRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 14:17:15 -0500
Received: from smtp.nokia.com ([192.100.122.233]:36419 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab0AZTRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 14:17:13 -0500
Date: Tue, 26 Jan 2010 21:15:06 +0200
From: Felipe Balbi <felipe.balbi@nokia.com>
To: "Balbi Felipe (Nokia-D/Helsinki)" <felipe.balbi@nokia.com>
Cc: ext David Brownell <david-b@pacbell.net>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Anton Vorontsov <avorontsov@ru.mvista.com>,
       Grazvydas Ignotas <notasas@gmail.com>,
       Madhusudhan Chikkature <madhu.cr@ti.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [RFC/PATCH 1/5] usb: otg: add notifier support
Message-ID: <20100126191506.GD20049@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <6ed0b2680912101251jeec28e6i216dfc51caab13aa@mail.gmail.com>
 <201001260316.20529.david-b@pacbell.net>
 <20100126141016.GD10690@nokia.com>
 <201001260707.23339.david-b@pacbell.net>
 <20100126190934.GC20049@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20100126190934.GC20049@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 26 Jan 2010 19:16:49.0855 (UTC) FILETIME=[1C411CF0:01CA9EBC]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jan 26, 2010 at 08:09:34PM +0100, Balbi Felipe (Nokia-D/Helsinki) wrote:
>well, if you have access to twl5031 docs you'd understand what I'm
>talking about, the charger detection involves at least 3 blocks on
>twl5031 plus musb to enable/disable pullups. The sequence is pretty much
>as below:

there's more which I forgot:

>1. vbus irq
>2. usb_gadget_disconnect()
>3. disable usb ldos

3.1 put transceiver in non-drivig mode

>4. switch usb3v1 supply from vbat to vbus (to let charger detection work
>on low bat)
>5. enable usb3v1 *only*
>6. call the notifier chain
>7. BCC module kicks charger detection
>8. disable usb3v1
>9. switch usb3v1 supply back to vbat

9.1 put transceiver back to normal mode

>10. enable usb ldos
>11. usb_gadget_connect() (necessary since we might be connected to
>charging port)

now it should be all fine.

-- 
balbi
