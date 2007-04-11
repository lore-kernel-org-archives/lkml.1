Return-Path: <linux-kernel-owner+w=401wt.eu-S1752851AbXDKOhO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851AbXDKOhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 10:37:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbXDKOhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 10:37:14 -0400
Received: from neon.samage.net ([85.17.153.66]:35113 "EHLO neon.samage.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752851AbXDKOhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 10:37:12 -0400
Message-ID: <1349.81.207.0.53.1176302225.squirrel@secure.samage.net>
In-Reply-To: <009501c77c22$2b4960f0$0864a8c0@scs1>
References: <4610D25F.7080005@ceid.upatras.gr>
    <p73r6r3yn9f.fsf@bingen.suse.de> <4610EDF9.9000601@sciensis.com>
    <4616BC09.2080509@tmr.com>
    <4152.81.207.0.53.1175900790.squirrel@secure.samage.net>
    <461715B4.9060701@tmr.com> <009501c77c22$2b4960f0$0864a8c0@scs1>
Date: Wed, 11 Apr 2007 16:37:05 +0200 (CEST)
Subject: Re: [PATCH resend][CRYPTO]: RSA algorithm patch
From: "Indan Zupancic" <indan@nul.nu>
To: "Tasos Parisinos" <t.parisinos@sciensis.com>
Cc: "Bill Davidsen" <davidsen@tmr.com>, "Andi Kleen" <andi@firstfloor.org>,
       herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
       randy.dunlap@oracle.com
User-Agent: SquirrelMail/1.4.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: -1.8
X-Scan-Signature: 40d4c7eb1a26805eb7fc8470f09949b1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, April 11, 2007 12:14, Tasos Parisinos wrote:
> If you are a vendor of a smart phone, a router, or worst, a point of sale
> terminal you care about three things. The first is that the end user can't open
> the device to probe it or alter it in a way that would create fraud. For example
> a salesman could alter a credit card reader to see all cards as genuine and do
> offline transactions.

I'd hope that for a smart phone and a router the owner can install whatever he wants
(that is, he has the private key). As for the card reader, I'd hope that using a
modified card reader isn't enough for fraud to succeed, or else the whole thing is
designed stupid. That said, the credit card system seems insecure anyway, with readers
being able to steal useful information.


> The second is that you dont want any eavesdropper
> hijacking connectionsto such devices and replacing your updates with his in a
> way that could create fraud. In that case the problem could be severe because
> you don't have a user's device altered but possibly hundrends of them. And the
> third thing is to do the first two as cheap as you can because in the embedded
> world, as one can understand competition is tough.

These are real problems.


> The first need is solved generally by embedding hot data in security access
> modules and hot software on chips or cryptomemories bla bla. Security can range
> from tamper resistance to tamper rensonsiveness in means of such casings that
> could detect any kind of intrusion attempt and erase all critical stuff,
> rendering a device useless. For an example think of a processor that has all
> its critical software and data inside it, on volatile memories. When this chip
> is not powered it uses an internal (or external) battery to keep these data
> alive. This chip can have sensors of heat, humidity, oscillator frequency
> imbalancies, short circuits, currents going in and out of its pins, even light,
> and be configured and programmed in a way to erase all critical data and
> software when some of the above variables goes out of envelope.

Read: http://www.cl.cam.ac.uk/TechReports/UCAM-CL-TR-630.pdf

There are other similar papers. The conclusion is that if someone really wants it,
he will get it from your device. Not sure if it was this paper or another one, but
volatile memory can be read out after the power went off. It's even possible to
retrieve overwritten data if it wasn't done very carefully, both RAM and flash.

If the tampering is done for a very short time, the detectors will probably miss it.
Or the tampering is done with the one thing the device wasn't protected against.
Or they think up some new way to bypass the protections.

Anyway, the question is what you're trying to protect. In general it's to keep the
code hidden, because there are plenty of obscure companies that steal that expensive
code and use it for their products. But it can also be a private key or something.


> The second need is solved by authentication and encryption. The system of
> authentication must be asymmetric because if it is symmetric and the first need
> is not well implemented then you may get really exposed. Of course you have to
> secure first the software that does this authentication on the device.

True. (Though asymmetric doesn't mean it has to be RSA. ;-)


> We at Sciensis are designing embedded systems and we had the need to create such
> a system for authentication. We have built it into the Linux kernel because this
> is neat, simple and costs less to implement.

Yes. But with that comes the obligation to publish your code under the GPL to your
customers, keep that in mind.


> As Indan said, in generic, its more
> difficult to secure entire filesystems and this gets even more difficult when
> you have your filesystem on removable media such as mmc or sd-cards.

Only true if that filesystem isn't initramfs embedded in the kernel library! Then it
gets the same protection as the kernel for free.


> So we thought, hell why not give it to others as well so we GPL'd it.

You did? We only saw a MPI implementation, nothing more. All the above mentioned
arguments and reasoning only applies to a complete implementation, not to an
incomplete partial solution, which on its own is useless. Don't mix up the binary
signing thing with a nice stand alone RSA crypto module.

That said, it was nice to share the RSA code, no matter what.


> Yes this thing does not have other in-kernel users yet
> but i always wondered who uses khazad cipher algorithm, lol. (ok i suppose all
> these symmetric cryptographic and digest options are all for IPSec, but khazad
> (?!), come on guys). I understand codebloat, firm policies, bitrot e.t.c but how
> can a thing be published and used if it is not brought out to the light?

I fully agree with this, but only for a RSA crypto API module.


> 1. Indan you have commented on an earlier patch that the multiplication
> algorithm can be optimized a lot. Please post anything you have in mind because
> that code is executed a lot.

I've no time right now, but I'll look it up when you've posted the crypto API version.


> 2. Making it a full blown Crypto API is possible, because RSA can be seen as a
> block cipher and you can hard code and compile the fixed size of the modulus and
> thus simplify code as well, but this will make it less generic and cumbersome in
> runtime (except if we add some kernel boot parameters).

As far as the memory management, I didn't mean to hardcode the size of the modulus,
but to have a hard coded limit (e.g. 4096 bits). The modulus can vary, as long as
it's less than the limit. As for the block size, it depends on what scheme you use.
In general the block size isn't exactly equal to the modulus, but smaller, and the
message is padded in some way. It depends on how you sign the binary hash. So maybe
it's best to move that decision to the user of the RSA module, and indeed use the
modulus as block size, in which case it would be variable and depend on the key used.
No idea how well the current crypto API copes with that, it might be a problem.


> But there is a problem
> with exponents... how would you pass them around using the current Crypto API
> structs? Would it be wiser to take this module out of Cryptocraphic Options menu
> and put it in the Library routines menu?

I don't know, I didn't look into the details yet. But I assume that at worst you
use a struct as key, and pass that transparently through the crypto API part.
But maybe there are better ways. Can try it out and use what seems best I suppose.


> 3. We decided not to GPL other parts of the binary signing mechanism because
> this are covered by some NDAs. So i must leave that to others to develop, or
> come back with a very-very different version of these parts and this will take
> time.

Well, you don't have much choice in the matter when using GPL software, I'm afraid.
You don't have to release it to everyone, only to your customers, but they're free
it give to anyone else they want. If that's not possible because of some NDA, then
you may not distribute the GPL code. The whole point of using GPL is that if someone
modifies the code, he's required to give back the modifications.

And squeezing out of this isn't possible in your situation as you don't have a
separate binary module, but have modified kernel code and are distributing the whole.

But I don't see why you're so mysterious about the rest anyway, because it looks rather
trivial to implement such binary signature checking thing. If it isn't trivial, then
small chance it's secure...

At least I won't ever buy "secure" hardware from any vendor who's mysterious about the
implemented protections. Because time after time it was proven that no matter how obscure
the protection is done, it's always bypassed if it couldn't stand on its own.
(Example: The GSM encryption used. Both reverse engineered and broken.)


> I think it is worth to try to make a version which will use the crypto api glue
> code and re-post...

Yes, certainly, independently from the rest of the implementation, which you might need
to move to userspace if you're really coy about it. (Though if it's only because of the
stupid NDA, then I'd consider replacing the NDA part with something of your own. NDA's
imply money drain.)

Greetings,

Indan


