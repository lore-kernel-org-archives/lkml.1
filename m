Return-Path: <linux-kernel-owner+w=401wt.eu-S967264AbXEGXdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967264AbXEGXdT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 19:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967249AbXEGXdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 19:33:15 -0400
Received: from mail4.sea5.speakeasy.net ([69.17.117.6]:48318 "EHLO
	mail4.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967244AbXEGXdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 19:33:14 -0400
Date: Mon, 7 May 2007 16:33:12 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Manu Abraham <abraham.manu@gmail.com>
cc: Markus Rechberger <mrechberger@gmail.com>,
       Linux DVB <linux-dvb@linuxtv.org>,
       Linux Kernel Mailing list <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [linux-dvb] DST/BT878 module customization (.. was: Critical
 points about ...)
In-Reply-To: <46389278.1070208@gmail.com>
Message-ID: <Pine.LNX.4.58.0705071526170.13823@shell2.speakeasy.net>
References: <d9def9db0704301417i214a17a8i1fdcbc69f837669@mail.gmail.com>
 <4636E0E2.5020601@simon.arlott.org.uk> <Pine.LNX.4.58.0705011500570.309@shell2.speakeasy.net>
 <46389278.1070208@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Manu Abraham wrote:
> > I've been aware of the problem with dst not fully using the dvb customization
> > systems(*) for a long time.  It came up when dvb_attach() et al were first
> > being integrated, well before any rejected patches or strongly worded emails
> > or whatever from certain people that I'm aware of.
> >
>
> Well, your understanding of the device is quite limited and hence your
> comments and patches.

Manu, have you actually looked at the patch?  It seems like you are just
rejecting everything that has anything to do with dst out of hand.

Can you point to any line of code there, and say what it breaks or what it
will make impossible?

> These features are not the characteristics of a DVB Frontend. Here there
> is a DVB frontend like the normal ones which is hidden behind another
> pseudo bridge (So you don't have *any* access to the frontend at large)

Again, did you actually look at the patch?  I never so much as used the
word frontend to describe the dst.  I didn't change the operation of the
dst in any way.  I didn't move it to a new place in the framework.

The bt8xx driver talks to the dst module via the dvb_frontend object, my
patch has nothing to do with this.  It is a simple patch for simple
programming issues and nothing to do with these larger issues you bring up.

> I would think that it would be *extremely* rude for a person to send in
> patches for a device that which you don't understand at all, when it is
> for limiting the capability of the said device

Is the problem that there is a bug in my patch?  Or is your problem that I
was rude in submitting any patch at all that had anything to do with your
code?  Do you feel that this part of the Linux kernel is owned by you, and
that no one else should be permitted to have anything to do with it?

> > (*) There are two customization/dependency control systems in DVB.  One is
> > dvb_attach(), the other is DVB_FE_CUSTOMISE.  They are not two entirely
> > separate systems, but overlap in their design a great deal.
>
> Here we have the attach method attaching different objects, but
> basically it can be handled for the frontend devices only (and that too
> that share a very common trait, in this case, frontends are coupled
> using the i2c bus) and not for other devices. Situation changes when you
> use another interface such as SPI, where the interface is not well defined.

This is not correct.  The dvb_attach() system has no assumption that it will
be used for a front-end device.  There are already users which are not
front-ends, such as tuners or lnb supply control chips, and yes, dst, which
will all know very well is not a frontend.

It also has nothing do with the i2c.  The attached device could be connected
in any way.  I plan to add dvb_attach() support for the cx88 secondary i2c bus
driver (aka vp3054), and that isn't even a different chip.

> > This design means the actual hard link between different drivers is limited to
> > each driver's single attach function (**).  By breaking this one link, we can
> > control which drivers must be loaded or linked to only those necessary or
> > wanted.  dvb_attach() and DVB_FE_CUSTOMISE are two different ways of
> > controlling these links.
>
> dvb_attach will have to go away for the DST. It doesn't work for the
> mentioned reasons that it is just pushing the device to a corner as a
> DVB frontend whereas it is not a DVB Frontend at all.

The dst is already using dvb_attach()!  I'm not changing that at all.

> being the author and maintainer of dst/dst_ca and maintainer of
> dvb-bt8xx, i NACK this change

Can one become a maintainer just be declaring ones self to be so?  Or is there
an expectation that a maintainer will in fact, maintain.  That is to say,
address concerns in a timely fashion, review patches and work in good faith to
resolve problems with said patches.

> What i would like to do is like this: Have the current state frozen as
> it is,

So as maintainer you are declaring that no changes of any kind are permitted?
That is to say, the code should become frozen, un-fixed and un-updated, in
other words, _unmaintained_.

How can you have it both ways, that you are the maintainer and that it should
be unmaintained?
