Return-Path: <linux-kernel-owner+w=401wt.eu-S1751597AbXDKKfO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751597AbXDKKfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 06:35:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751695AbXDKKfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 06:35:13 -0400
Received: from mailout15.yourhostingaccount.com ([65.254.253.120]:36123 "EHLO
	mailout15.yourhostingaccount.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751597AbXDKKfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 06:35:11 -0400
X-Greylist: delayed 1283 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 06:35:11 EDT
Message-ID: <009501c77c22$2b4960f0$0864a8c0@scs1>
From: "Tasos Parisinos" <t.parisinos@sciensis.com>
To: "Bill Davidsen" <davidsen@tmr.com>, "Indan Zupancic" <indan@nul.nu>
Cc: "Andi Kleen" <andi@firstfloor.org>, <herbert@gondor.apana.org.au>,
       <linux-kernel@vger.kernel.org>, <randy.dunlap@oracle.com>
References: <4610D25F.7080005@ceid.upatras.gr>    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>    <4616BC09.2080509@tmr.com> <4152.81.207.0.53.1175900790.squirrel@secure.samage.net> <461715B4.9060701@tmr.com>
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
Date: Wed, 11 Apr 2007 13:14:06 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
X-EN-UserInfo: 6b5ac0c6b5a8f649d336ffa6ba3f3bc4:297516c839f78035fb456ced5af6b435
X-EN-AuthUser: tparisinos@sciensis.com
X-EN-OrigIP: 88.218.94.102
X-EN-OrigHost: dsl-88-218-94-102.customers.vivodi.gr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello to everybody

-----

Firstly i want to thank everybody for reviewing this code and posting all your
usefull comments

-----

Secondly i would like to give a generic (as possible) example of use of this
module. More and more nowadays Linux has started to be ported and running in a
wide variety of devices that are mostly described by the word embedded, from
mobile phones and smart phones to gadgets and multimedia players and from
routers to payment, identification, access and security systems. There is also
the big arena of industrial digital equipment as plc, motion controllers e.t.c.
These devices were running till now some other on-chip and in many cases
proprietary operating systems. The processors and the resources used where a lot
less than a full fledged OS needs to run on. Exception to all these devices
where some pda's. But now the processors used in embedded devices have evolved a
lot and while hardware is getting faster and cheaper the cost of creating and
maintaining the os has grown to a point where more and more designers need to
use either Linux or some OS of the windows family (CE, XP embedded, mobile).
The time is close where you are going to have the resources on-chip to download
and run a kernel from within a chip. As anyone can understand these devices are
not like servers, for example, hidden away in some well protected computer room,
with dedicated administrators and they can't be compared at all with
workstations and personal computers where noone usually spents time to intrude,
unless to practice his hobby. Most if not all of the designers and vendors of
such digital devices will very soon need to have a way of centrally and
transparently updating the software and personalization data in such devices in
a secure way over public networks.

If you are a vendor of a smart phone, a router, or worst, a point of sale
terminal you care about three things. The first is that the end user can't open
the device to probe it or alter it in a way that would create fraud. For example
a salesman could alter a credit card reader to see all cards as genuine and do
offline transactions. The second is that you dont want any eavesdropper
hijacking connectionsto such devices and replacing your updates with his in a
way that could create fraud. In that case the problem could be severe because
you don't have a user's device altered but possibly hundrends of them. And the
third thing is to do the first two as cheap as you can because in the embedded
world, as one can understand competition is tough.

The first need is solved generally by embedding hot data in security access
modules and hot software on chips or cryptomemories bla bla. Security can range
from tamper resistance to tamper rensonsiveness in means of such casings that
could detect any kind of intrusion attempt and erase all critical stuff,
rendering a device useless. For an example think of a processor that has all
its critical software and data inside it, on volatile memories. When this chip
is not powered it uses an internal (or external) battery to keep these data
alive. This chip can have sensors of heat, humidity, oscillator frequency
imbalancies, short circuits, currents going in and out of its pins, even light,
and be configured and programmed in a way to erase all critical data and
software when some of the above variables goes out of envelope.

The second need is solved by authentication and encryption. The system of
authentication must be asymmetric because if it is symmetric and the first need
is not well implemented then you may get really exposed. Of course you have to
secure first the software that does this authentication on the device.

We at Sciensis are designing embedded systems and we had the need to create such
a system for authentication. We have built it into the Linux kernel because this
is neat, simple and costs less to implement. As Indan said, in generic, its more
difficult to secure entire filesystems and this gets even more difficult when
you have your filesystem on removable media such as mmc or sd-cards. So we
thought, hell why not give it to others as well so we GPL'd it. It was first 
developed on an AVR32 so it is put for review on www.avr32linux.org (to be honest
it was published there rather late) and also given to you to review as well
because all flavours of embedded Linux whether they are run on ARM or AVR or PPC
BLACKFIN etc are all derived from the mainline, so having it as portable code in the
mainline you make it accessible to all these fellows wanting to use it in the
embedded world. Well it will be quite useless for your PC so dont select it when
you compile your kernel. Yes this thing does not have other in-kernel users yet
but i always wondered who uses khazad cipher algorithm, lol. (ok i suppose all
these symmetric cryptographic and digest options are all for IPSec, but khazad
(?!), come on guys). I understand codebloat, firm policies, bitrot e.t.c but how
can a thing be published and used if it is not brought out to the light?

-----
Thirdly some technical stuff that Indan brought up

1. Indan you have commented on an earlier patch that the multiplication
algorithm can be optimized a lot. Please post anything you have in mind because
that code is executed a lot.

2. Making it a full blown Crypto API is possible, because RSA can be seen as a
block cipher and you can hard code and compile the fixed size of the modulus and
thus simplify code as well, but this will make it less generic and cumbersome in
runtime (except if we add some kernel boot parameters). But there is a problem
with exponents... how would you pass them around using the current Crypto API
structs? Would it be wiser to take this module out of Cryptocraphic Options menu 
and put it in the Library routines menu?

3. We decided not to GPL other parts of the binary signing mechanism because
this are covered by some NDAs. So i must leave that to others to develop, or
come back with a very-very different version of these parts and this will take
time.

I think it is worth to try to make a version which will use the crypto api glue
code and re-post...

Best regards
Tasos Parisinos
-


