Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbXINVHp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbXINVHp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:07:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXINVHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:07:38 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:18107 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958AbXINVHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:07:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mZknKM03mor+DboXjLVn1nCD3qwkEQcWCEDEkhPLtbmo93JYLQFKhXQyk0EGraBzVczX+SvXS7j0BznqkEJU2ZlWGZwQ4S+uQPufNHmVr2IKTmhJgmds2zHzsOyZjq8B/bA2bqhDi4MrePNR4vieub84bAQ0yiSo4Cbjw3UULq4=
Message-ID: <c8b4dbe10709141407p757d0909s5a4d49a7eb44d929@mail.gmail.com>
Date: Fri, 14 Sep 2007 22:07:36 +0100
From: "Aidan Thornton" <makosoft@googlemail.com>
To: "Michael Krufky" <mkrufky@linuxtv.org>
Subject: Re: [linux-dvb] [PATCH] Userspace tuner
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Manu Abraham" <abraham.manu@gmail.com>,
       "video4linux-list@redhat.com" <video4linux-list@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-dvb@linuxtv.org" <linux-dvb@linuxtv.org>
In-Reply-To: <37219a840709141220p543b0da9x53f48eabc1cfe8c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d9def9db0709121546h67d3d1ceuf001ab1d798fde92@mail.gmail.com>
	 <d9def9db0709131617l14495fecp5e15f91aa5dd9474@mail.gmail.com>
	 <46E9DDC7.4000403@hauppauge.com>
	 <d9def9db0709132338v64ecdcf2ib4e69f1a9c986a5c@mail.gmail.com>
	 <20070914113838.GA29962@linuxtv.org>
	 <d9def9db0709140936u64041927p9e472f70d5a036c5@mail.gmail.com>
	 <1189791161.2363.8.camel@gaivota>
	 <d9def9db0709141046h3b2dee40l398f5ed1bbc19322@mail.gmail.com>
	 <1189794551.2363.36.camel@gaivota>
	 <37219a840709141220p543b0da9x53f48eabc1cfe8c9@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 9/14/07, Michael Krufky <mkrufky@linuxtv.org> wrote:
> On 9/14/07, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:
> > > > - The hybrid tuner support, that where your requirement, when all those
> > > > discussions started, were already added to the subsystem. So now, an
> > > > hybrid tuner can be accessed by both DVB and V4L devices;
> > > >
> > >
> > > It's far more complex as the thing which is implemented there.
> > > The only thing that has been implemented is that one moduleformat
> > > can be loaded by the v4l and by the dvb framework nothing else at the
> > > moment. I told you at the kernel summit about that and I think you
> > > knew about that before.
> > >
> > > Just to quote some text:
> > > "Right now, a separate instance of the driver is used for analog /
> > > digital tuning.  In order to use a single instance, we will have to
> > > store a pointer to the dvb_frontend structure on the bridge level, but
> > > there are various other prerequisites that must be dealt with before we
> > > get to that point.
> > >
> > > We _will_ get there though, eventually."
> >
> > Maybe it is still not perfect. Feel free to improve it. Several people
> > from the community, including me, already offered you help to add your
> > driver, reworking on the 5% of the stuff that aren't compatible with the
> > V4L/DVB core API design.
>
> For clarification, Markus is quoting me, above.
>
> The idea is to eventually store a pointer to the dvb_frontend
> structure on the bridge level to be used as a single entry point
> between the analog and digital subsystems.  However, we are not yet
> ready for this, as the refactoring process has a lot more to be done
> beforehand.

I think this will require a rethink of either how the em2880-dvb
driver works or how frontend drivers work. The current API expects
users to initialise their frontend and then bind a tuner to it.
em2880-dvb is a sort of subdriver that attaches to the main driver,
and doesn't have any control over when or how it initialises its
tuner, so it can't delay tuner initialisation until the frontend has
been initialised. (I don't think it's the only hybrid driver that
works this way either). Of course, I could be missing something.

> There is no reason why the Xceive driver cannot be merged into the
> current development tree using the hybrid tuner framework as it stands
> today.

I'm not convinced this is entirely true. In order to avoid unnecessary
reinitialisation of the device, the driver needs to know whether the
device is in analog or digital mode, and I can't see a way of doing it
with the current API. (I think existing drivers, such as the xc2028
driver in one branch, use the older analog API and make the digital
driver a wrapper around it.) Again, I may be missing something.

Aidan
