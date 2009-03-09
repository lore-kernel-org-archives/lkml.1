Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZCIUC1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZCIUC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 16:02:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZCIUCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 16:02:18 -0400
Received: from mail-fx0-f176.google.com ([209.85.220.176]:50170 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbZCIUCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 16:02:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ASRhZjK3iqTsMX3s/RXZ6tKE7AdJ/srOGUIS/SG55esYHbhkr6ul85iJWa+mdkNRQt
         MWq1fdsj37cb4pnI89eBNN3w3pVnNRND2z8kWAW4xMEOGoIM4vEVCZm04U5C0eqoM76o
         yaYXdPYoHwsbisFjXpEQUwWqmNaXCIVDosJeA=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1236628301.11146.1.camel@maxim-laptop>
References: <Pine.LNX.4.44L0.0903091511030.4674-100000@iolanthe.rowland.org>
	 <1236628301.11146.1.camel@maxim-laptop>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 22:02:08 +0200
Message-Id: <1236628928.11146.8.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 21:51 +0200, Maxim Levitsky wrote:
> On Mon, 2009-03-09 at 15:12 -0400, Alan Stern wrote:
> > On Mon, 9 Mar 2009, Maxim Levitsky wrote:
> > 
> > > T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
> > > D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > > P:  Vendor=03f0 ProdID=4117 Rev= 1.00
> > > S:  Manufacturer=Hewlett-Packard
> > > S:  Product=HP LaserJet 1018
> > > S:  SerialNumber=KP06J6V
> > > C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 98mA
> > > I:* If#= 0 Alt= 0 #EPs= 2 Cls=07(print) Sub=01 Prot=02 Driver=(none)
> > > E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > > E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > > 
> > > T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  2 Spd=480 MxCh= 0
> > > D:  Ver= 2.00 Cls=ef(unk. ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> > > P:  Vendor=064e ProdID=a101 Rev= 1.00
> > > S:  Manufacturer=SuYin
> > > S:  Product=Acer CrystalEye webcam
> > > S:  SerialNumber=CN0314-OV03-VA-R02.00.00
> > > C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
> > > A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
> > > I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
> > > E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
> > > I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
> > > I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS= 256 Ivl=125us
> > > I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS= 800 Ivl=125us
> > > I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS=1600 Ivl=125us
> > > I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS=2400 Ivl=125us
> > > I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > > E:  Ad=81(I) Atr=05(Isoc) MxPS=3000 Ivl=125us
> > 
> > I wonder...  Does it make any difference if you unplug that webcam, or 
> > plug it into the other high-speed bus?
> Can't do so, its built-in.
But I can plug printer into another usb bus, I found a single port (this
notebook has 4 ports) that is on bus #1, problem is that it it on the
other side of the notebook, and from the point where the printer stands
the cable isn't long enough to reach it.

I do some more testing soon, buy another and longer cable

Anyway couldn't crash the printer even once with 'good' driver.
In other words I was sure I found a cause for this problem, but it seems
I found nothing or maybe a bad cable (I did some tests in windows - but
as things unroll, this printer can work quite reliably sometimes that
is)

So again big thanks,
	Best regards,
		Maxim Levitsky

