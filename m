Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZCITwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZCITwB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 15:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751809AbZCITvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 15:51:51 -0400
Received: from mail-bw0-f178.google.com ([209.85.218.178]:60817 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751269AbZCITvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 15:51:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=SgUMpzV62gvq9y0cLcoA0qYK9hH16gscLdIrW5jjBkgAU0vFJrIh1D+dXiMRWqntCd
         yRKOkcQdTNY4fWVLaHKUGagGuWHVstR/eYLHTBUbPMKcueCFsm0z1XAoiMfVAeTqKpSY
         oWG41Qt2zn8hkenq8mD7OhdsUyLP/v7N/vbqY=
Subject: Re: [BUG] Loading both ehci-hcd and uhci-hcd drivers causes my
 printer to fail
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0903091511030.4674-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0903091511030.4674-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 21:51:41 +0200
Message-Id: <1236628301.11146.1.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-09 at 15:12 -0400, Alan Stern wrote:
> On Mon, 9 Mar 2009, Maxim Levitsky wrote:
> 
> > T:  Bus=02 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#=  7 Spd=480 MxCh= 0
> > D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
> > P:  Vendor=03f0 ProdID=4117 Rev= 1.00
> > S:  Manufacturer=Hewlett-Packard
> > S:  Product=HP LaserJet 1018
> > S:  SerialNumber=KP06J6V
> > C:* #Ifs= 1 Cfg#= 1 Atr=c0 MxPwr= 98mA
> > I:* If#= 0 Alt= 0 #EPs= 2 Cls=07(print) Sub=01 Prot=02 Driver=(none)
> > E:  Ad=01(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > E:  Ad=81(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> > 
> > T:  Bus=02 Lev=01 Prnt=01 Port=03 Cnt=02 Dev#=  2 Spd=480 MxCh= 0
> > D:  Ver= 2.00 Cls=ef(unk. ) Sub=02 Prot=01 MxPS=64 #Cfgs=  1
> > P:  Vendor=064e ProdID=a101 Rev= 1.00
> > S:  Manufacturer=SuYin
> > S:  Product=Acer CrystalEye webcam
> > S:  SerialNumber=CN0314-OV03-VA-R02.00.00
> > C:* #Ifs= 2 Cfg#= 1 Atr=80 MxPwr=500mA
> > A:  FirstIf#= 0 IfCount= 2 Cls=0e(video) Sub=03 Prot=00
> > I:* If#= 0 Alt= 0 #EPs= 1 Cls=0e(video) Sub=01 Prot=00 Driver=uvcvideo
> > E:  Ad=83(I) Atr=03(Int.) MxPS=  16 Ivl=4ms
> > I:* If#= 1 Alt= 0 #EPs= 0 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > I:  If#= 1 Alt= 1 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS= 128 Ivl=125us
> > I:  If#= 1 Alt= 2 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS= 256 Ivl=125us
> > I:  If#= 1 Alt= 3 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS= 800 Ivl=125us
> > I:  If#= 1 Alt= 4 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS=1600 Ivl=125us
> > I:  If#= 1 Alt= 5 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS=2400 Ivl=125us
> > I:  If#= 1 Alt= 6 #EPs= 1 Cls=0e(video) Sub=02 Prot=00 Driver=uvcvideo
> > E:  Ad=81(I) Atr=05(Isoc) MxPS=3000 Ivl=125us
> 
> I wonder...  Does it make any difference if you unplug that webcam, or 
> plug it into the other high-speed bus?
Can't do so, its built-in.


Best regards,
	Maxim Levitsky

