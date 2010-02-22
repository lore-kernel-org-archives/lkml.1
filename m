Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab0BVTYg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:24:36 -0500
Received: from saarni.dnainternet.net ([83.102.40.136]:55802 "EHLO
	saarni.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0BVTYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:24:35 -0500
X-Spam-Flag: NO
X-Spam-Score: 0.032
From: Anssi Hannula <anssi.hannula@iki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes" causes gobi_loader to hang
Date: Mon, 22 Feb 2010 21:24:27 +0200
User-Agent: KMail/1.13.0 (Linux/2.6.33-desktop-0.rc8.1mnb; KDE/4.4.0; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       dvomlehn@cisco.com, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1002221408200.1251-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201002222124.27777.anssi.hannula@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On maanantai 22 helmikuu 2010 21:10:33 Alan Stern wrote:
> On Mon, 22 Feb 2010, Anssi Hannula wrote:
> > I guess that would suggest that the device doesn't allow the
> > initialization data to be broken into packets arbitrarily (though some
> > differences seem allowed, as the windows driver transmits them
> > differently).
> > 
> > Does this mean a tty interface is ill-suited for the microcode upload,
> > and instead qcserial should use the kernel's generic microcode upload
> > mechanism or the userspace should use libusb to do it?
> 
> I don't know.  Didn't the old successful code use a tty interface?

Yes, but does the tty interface guarantee that the data of one write call is 
sent as one packet to the device?

If I understood this correctly, it seems the changes have caused it to now 
concatenate short writes into one packet, which the device doesn't seem to 
like.

-- 
Anssi Hannula
