Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbXJWPyn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbXJWPyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 11:54:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbXJWPyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 11:54:33 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:1864 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbXJWPyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 11:54:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ptsWuxcs+S7LNHm2MgFX72TkDhQUzkR4WI+66nQFr8h92t8H65wmj7i688kihVLmv1l6xj2LPdRwo7j3Q0dKypTjW79BuZHtnEG87NUJffY+3FgBddeXWqGNFy/rn2hEQdkMT7p+OZjCyPWNnD4lafJNjzd9LA8itPoygZTq3hk=
Message-ID: <d120d5000710230854j28502be6xd5a0fd8d2fab3b77@mail.gmail.com>
Date: Tue, 23 Oct 2007 11:54:29 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH] Map volume and brightness events on thinkpads
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeremy Katz" <katzj@redhat.com>, linux-kernel@vger.kernel.org,
       davej@redhat.com
In-Reply-To: <20071018223915.GA4483@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071016184606.GB25181@srcf.ucam.org>
	 <d120d5000710161312r5676cad8o60e0790a4e8d5256@mail.gmail.com>
	 <alpine.LFD.0.999.0710161325570.6887@woody.linux-foundation.org>
	 <d120d5000710170857i3f534544pe9cab0ca6c1b0aa4@mail.gmail.com>
	 <20071017162827.GA9778@srcf.ucam.org>
	 <20071017173532.GB2974@khazad-dum.debian.net>
	 <d120d5000710171159p617115d9w862aadf266c2470c@mail.gmail.com>
	 <20071017204250.GA13377@khazad-dum.debian.net>
	 <d120d5000710180737yeba5445tdb3b302ed6f7a802@mail.gmail.com>
	 <20071018223915.GA4483@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> On Thu, 18 Oct 2007, Dmitry Torokhov wrote:
> > On 10/17/07, Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:
> > > Still, I was
> > > thinking about it, and a doubt came to mind: would it cause problems for a
> > > bitmap to share the function for EV_foo and EV_foo notifications?
> >
> > Not sure if I follow... Are you talking about bringing KEY_*_NOTIFY
> > into EV_KEY "namespace"? Could you elaborate?
>
> Suppose we define a "EV_* is a notify event" bit to set in the event type
> field of an input event.
>
> Now, any type of event can be a notify event or a normal event, depending on
> wether this bit is set.
>
> However, the input layer keeps track of which events of a given type can be
> sent by an input device using bitmaps, for every type of event.  And this
> bitmap now would mean "input device may issue a normal event or a notify
> event", not just "input device may issue a normal event".
>
> I am not sure if that would cause trouble?
>

Like I said this would prevent userspace to know true capabilities of
the input device
in question. Probably simply adding separate key notify events (such
as KEY_BRIGHTNESSUP_NOTIFY) to EV_KEY instead of creating EV_NOTIFY is
not such a bad idea - this way we can fix keymap from userspace (if
needed) instead of needing to modify the krenel.

So, EV_KEY (and extending KEY_MAX to 1024) or EV_NOTIFY?

-- 
Dmitry
