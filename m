Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbZHFMvN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbZHFMvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 08:51:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbZHFMvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 08:51:13 -0400
Received: from mr1.bfh.ch ([147.87.250.50]:34908 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752495AbZHFMvM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 08:51:12 -0400
X-Greylist: delayed 1878 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Aug 2009 08:51:12 EDT
From: Zimmermann Christoph <christoph.zimmermann@bfh.ch>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 6 Aug 2009 14:50:26 +0200
Subject: RESEND: Re: Is anyone maintaining (or even using) usbtmc?
Thread-Topic: RESEND: Re: Is anyone maintaining (or even using) usbtmc?
Thread-Index: AQHKFpSTIPlIjuYRAEOYf0pUWfjYag==
Message-ID: <8288F66EF13DBA41AD8CBFDA64D8FFA31629782E@nyx.bfh.ch>
Accept-Language: de-DE, fr-CH
Content-Language: de-CH
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: de-DE, fr-CH
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-PMWin-Version: 3.0.2.0, Antivirus-Engine: 2.89.1, Antivirus-Data: 4.44E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i've asked also some of your questions two month ago.

i'm a tmc driver user only. i use it to develop my firmware for a
cypress fx2 based tmc device.

i've made some bugreporting to greg and to the mailinglist (now i'm not
sure anymore if all my mails arrived on the mailinglist. the gmame
archive does not list all mails. the other archives are even worse).

since then two ore tree small patches are sent to the mailinglist. but
none seemed to adress my bugs (one patch was about a memory leak)

> If the answer is no (as I suspect it is), then I might give fixing it
> a shot the week after next, when I'll be camping out in Virginia with
> this thing for awhile.  In that case, I have another question:

do it. greg is the maintainer of the whole usb stuff and is working
really hard. so i understand that he only has little time on "our"
usbtmc bugs. in my opionion it's good when you do it to help greg with
it. he still is the maintainer and has to sign of your patches.

the other thing is, that i belive, please correct me, that greg don't
has an usbtmc device to test with. for me it seems that there is lack
of testing in the usbtmc driver. thats why i assume this.

as i wrote in my older mails, i've never worked on the kernel source. i
can do some testing with different devices (in our lab we have serveral
tmc devices).

> Is anyone using usbtmc, or, more specifically, does anyone care about
> backward compatibility?

it doesn't look like that. i don't care if the interface changes. i'm
still working with the old agilent one until the mainline one works.

> Finally, I see no way to read the USB488 status byte or detect a
> status interrupt.
>
> >
> >> Is anyone using usbtmc, or, more specifically, does anyone care
> >> about backward compatibility?
> >
> > What do you want to change in the driver interface?
>
> The main compatibility-breaking change is that I'd like to see
> close/reopen go through the whole resynchronization procedure so that
> the device starts in a sane state.  Currently I restore sanity by
> doing a bunch of reads and ignoring ETIMEDOUT.
> If not, then I'll be less careful to preserve the interface, even
> though I'm not really sure that there's much of interest to preserve.

to read the USB488 status byte i guess that there is still an ioctl
function for it (was there in the opensource agilent driver) but you
can get the status byte with a normal "*STB?" query.

the lack of interrupt status reporting is an important one. so you have
to quess, or do stupid polling, until your device is finished working.
the normal way is to set "opc?" and do something else until the
response from the interrupt endpoint arrives.

christoph
