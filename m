Return-Path: <linux-kernel-owner+w=401wt.eu-S1752467AbYLUWCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbYLUWCV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:02:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYLUWCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:02:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37993 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbYLUWCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:02:08 -0500
Date: Sun, 21 Dec 2008 14:02:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
Message-Id: <20081221140200.40c1fec1.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com>
	<20081220221253.e09b1b1f.akpm@linux-foundation.org>
	<f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com>
	<494E20F7.7050106@gmail.com>
	<f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
	<alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz>
	<alpine.DEB.2.00.0812211441300.7101@parag-desktop>
	<alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008 22:48:21 +0100 (CET) Jiri Kosina <jkosina@suse.cz> wrote:

> On Sun, 21 Dec 2008, Parag Warudkar wrote:
> 
> > The usbmouse and usbkbd modules are not supposed to be used with regular 
> > USB mice and keyboards. Make them depend on EMBEDDED to prevent them from 
> > being built and loaded on non-EMBEDDED configs.
> > 
> > Signed-off-by: Parag Warudkar <parag.lkml@gmail.com>
> > 
> > diff --git a/drivers/hid/usbhid/Kconfig b/drivers/hid/usbhid/Kconfig
> > index 5d9aa95..4edb3be 100644
> > --- a/drivers/hid/usbhid/Kconfig
> > +++ b/drivers/hid/usbhid/Kconfig
> > @@ -45,7 +45,7 @@ config USB_HIDDEV
> >  	  If unsure, say Y.
> >  
> >  menu "USB HID Boot Protocol drivers"
> > -	depends on USB!=n && USB_HID!=y
> > +	depends on USB!=n && USB_HID!=y && EMBEDDED
> >  
> >  config USB_KBD
> >  	tristate "USB HIDBP Keyboard (simple Boot) support"
> 
> So do I get it right that the only reason of the problem you were seeing 
> was that in the 2.6.27 kernel you have compiled usbhid module, which was 
> then used for driving your mouse,but in 2.6.28-rcX you compiled and used 
> 'usbmouse' instead, and therefore this is not a regression?
> 

Shouldn't usbmouse support two-dimensional mice as well?
