Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbZBCHA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbZBCHA2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 02:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbZBCHAP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 02:00:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48767 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752084AbZBCHAO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 02:00:14 -0500
Date: Mon, 2 Feb 2009 22:59:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Max Weninger <max.weninger@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Niels de Vos <niels.devos@wincor-nixdorf.com>,
       linux-usb@vger.kernel.org, Daniel Ritz <daniel.ritz@gmx.ch>
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not
 working
Message-Id: <20090202225929.e10dc57b.akpm@linux-foundation.org>
In-Reply-To: <20090131230901.13e2058e@vostro.foo.com>
References: <20090125234902.7605fd16@zork.foo.com>
	<497D9469.3030908@wincor-nixdorf.com>
	<20090126124941.4f67aaf5@shire2>
	<497DA8E3.5070006@wincor-nixdorf.com>
	<20090127013806.5e31199f@zork.foo.com>
	<20090127014822.780ecb90@zork.foo.com>
	<20090127020529.4070840b@zork.foo.com>
	<20090130151836.891f3204.akpm@linux-foundation.org>
	<20090131230901.13e2058e@vostro.foo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Jan 2009 23:09:01 +0100 Max Weninger <max.weninger@gmail.com> wrote:

> Hi to all
> 
> On Fri, 30 Jan 2009 15:18:36 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > (cc restored - please jsut do reply-to-all, always)
> > 
> > On Tue, 27 Jan 2009 02:05:29 +0100
> > Max Weninger <max.weninger@gmail.com> wrote:
> > 
> > > Hi again
> > > 
> > > On Tue, 27 Jan 2009 01:48:22 +0100
> > > Max Weninger <max.weninger@gmail.com> wrote:
> > > 
> > > > On Tue, 27 Jan 2009 01:38:06 +0100
> > > > Max Weninger <max.weninger@gmail.com> wrote:
> > > > 
> > > > > Hi
> > > > > 
> > > > > On Mon, 26 Jan 2009 13:13:23 +0100
> > > > > Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> > > > > 
> > > > > > Max Weninger wrote:
> > > > > > > Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
> > > > > > >> You can obviously download the drivers from
> > > > > > >> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
> > > > > > >>
> > > > > > >> It would be great if eGalax could be convinced to get these
> > > > > > >> drivers included in main-line ;)
> > > > > > > 
> > > > > > > Thanks for your quick reply
> > > > > > > BUT: I have tried those driver also
> > > > > > > 
> > > > > > > I tried this "brandnew" one (but also older ones)
> > > > > > > http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416/TouchKit-2.06.2410-32b-k26.tar.gz
> > > > > > > after making it compile for 2.6.28.2 :)
> > > > > > > since there is source code delivered
> > > > > > 
> > > > > > For what it's worth; the version we use from eGalax is
> > > > > > 1.0.3.1701. I don't have the hardware here atm, so I can't
> > > > > > test an other driver now.
> > > > > 
> > > > > I tried kernel 2.6.23.17 and there the touchscreen is recognized
> > > > > using the builtin usbtouchscreen driver
> > > > 
> > > > It also works with 2.6.26.8
> > > 
> > > After comparing the usbtouchscreen.c sources between the different
> > > versions I got it working by commenting the follwoing lines
> > > 
> > > ...
> > > #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> > >         /* ignore the HID capable devices, handled by usbhid */
> > >         {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =
> > > DEVTYPE_IGNORE}, {USB_DEVICE_HID_CLASS(0x0eef,
> > > 0x0002), .driver_info = DEVTYPE_IGNORE}, ...
> > > 
> > > Now the entry in /proc/bus/input/devices is created as in the
> > > older versions.
> > > 
> > > So it seems that usbhid is not correctly handling my type
> > > of touchscreen if I understand the comment there correctly
> > > 
> > 
> > So... how do we fix this for real?
> 
> Well I am really not an expert in kernel programming :-)
> I found out that these lines where added based on this thread from 2008
> 
> http://kerneltrap.org/mailarchive/linux-kernel/2008/6/28/2286264/thread
> 
> So all I can do is to provide any help in testing if needed
> 

(optimistically cc'ing Daniel).
