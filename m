Return-Path: <linux-kernel-owner+w=401wt.eu-S1765496AbXLOIJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765496AbXLOIJ7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 03:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754715AbXLOIJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 03:09:50 -0500
Received: from smtp.witbe.net ([81.88.96.48]:46459 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750856AbXLOIJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 03:09:49 -0500
Date: Sat, 15 Dec 2007 08:08:31 +0000
From: Paul Rolland <rol@as2917.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Pavel Machek <pavel@ucw.cz>,
       Ingo Molnar <mingo@elte.hu>, "David P. Reed" <dpreed@reed.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, Rene Herman <rene.herman@keyaccess.nl>,
       rol@witbe.net
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on
 some AMD64x2 laptops, etc.
Message-ID: <20071215080831.404cdb32@tux.DEF.witbe.net>
In-Reply-To: <20071214232955.545ab809@the-village.bc.nu>
References: <469578CD.3080609@reed.com>
	<1184216528.12353.203.camel@chaos>
	<1184218962.12353.209.camel@chaos>
	<46964352.7040301@reed.com>
	<1184253339.12353.223.camel@chaos>
	<469697C6.50903@reed.com>
	<1184274754.12353.254.camel@chaos>
	<4761F193.7090400@reed.com>
	<20071214131502.GA14359@elte.hu>
	<4762C551.5070003@zytor.com>
	<20071214210652.GB28793@elf.ucw.cz>
	<4763001A.1070102@zytor.com>
	<20071214232955.545ab809@the-village.bc.nu>
Organization: AS2917.net
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, 14 Dec 2007 23:29:55 +0000
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Fri, 14 Dec 2007 14:13:46 -0800
> "H. Peter Anvin" <hpa@zytor.com> wrote:
> 
> > Pavel Machek wrote:
> > > On Fri 2007-12-14 10:02:57, H. Peter Anvin wrote:
> > 
> > How long will that take to boot on a 386?
> 
> Well the dumb approach to fix that would seem to be to initialise it to
> 
> 	cpu->family   3 -> 50MHz 4 -> 300Mhz 5-> etc...

Just an idea : from what I've read, the problem (port 80 hanging) only occurs
on 'modern' machines... So why not :
 - use port 80 for old CPUs (PII, PIII) where it has never really been
   a problem,
 - use the cpu->family to do a best match for CPU freq
thus we could avoid increasing boot time too much...

Paul


