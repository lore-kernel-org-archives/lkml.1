Return-Path: <linux-kernel-owner+w=401wt.eu-S1752722AbXLKHrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbXLKHrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 02:47:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXLKHrc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 02:47:32 -0500
Received: from smtp.witbe.net ([81.88.96.48]:59795 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbXLKHrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 02:47:31 -0500
X-Greylist: delayed 317 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Dec 2007 02:47:31 EST
Date: Tue, 11 Dec 2007 08:40:59 +0100
From: Paul Rolland <rol@as2917.net>
To: David Newall <david@davidnewall.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rene Herman <rene.herman@keyaccess.nl>, Pavel Machek <pavel@ucw.cz>,
       Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "David P. Reed" <dpreed@reed.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
Message-ID: <20071211084059.3d03e11d@tux.DEF.witbe.net>
In-Reply-To: <475DEB23.1000304@davidnewall.com>
References: <475879CD.9080006@reed.com>
	<p733auekcly.fsf@bingen.suse.de>
	<20071207160439.71b7f46a@the-village.bc.nu>
	<20071209125458.GB4381@ucw.cz>
	<20071209165908.GA15910@one.firstfloor.org>
	<20071209212513.GC24284@elf.ucw.cz>
	<475CBDD7.5050602@keyaccess.nl>
	<m3bq8y23de.fsf@maximus.localdomain>
	<475DE37F.20706@davidnewall.com>
	<475DE6F4.80702@zytor.com>
	<475DEB23.1000304@davidnewall.com>
Organization: AS2917.net
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 11 Dec 2007 12:12:59 +1030
David Newall <david@davidnewall.com> wrote:

> H. Peter Anvin wrote:
> > David Newall wrote:
> >
> > I think a single ISA bus transaction is 1 µs, so two of them back to 
> > back should be 2 µs, not 8 µs...
> 
> Exactly.  You think it's 2us, but the documentation doesn't say.  The _p 
> functions are generic inasmuch as they provide an unspecified delay.  

Well, if the delay is so much unspecified, what about _reading_ port 0x80 ?
Will the delay be shorter ? And if so, what about reading port 0x80 and
writing the value back ?
inb  al,0x80
outb 0x80,al

I've been wondering since the beginning of this thread if the problem is not
just the value we put to port 0x80, not writing to the port...

Just my 0.02 Eur...

Paul


-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
Witbe.net SA                                Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

Please no HTML, I'm not a browser - Pas d'HTML, je ne suis pas un navigateur 
"Some people dream of success... while others wake up and work hard at it" 

"I worry about my child and the Internet all the time, even though she's too 
young to have logged on yet. Here's what I worry about. I worry that 10 or 15 
years from now, she will come to me and say 'Daddy, where were you when they 
took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 
