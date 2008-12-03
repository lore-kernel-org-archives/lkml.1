Return-Path: <linux-kernel-owner+w=401wt.eu-S1756299AbYLCBBA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756299AbYLCBBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 20:01:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754917AbYLCBAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 20:00:07 -0500
Received: from mail-gx0-f18.google.com ([209.85.217.18]:37789 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756237AbYLCBAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 20:00:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NDpZTXz5i/2bFQpdDmpnFFIENWBz6hn0DJpctGZprw/u2LpG4vcR+n3j1fnTixoxMa
         Z/MC4YG/nlf+F8C2YJuWGw4QfIKNuPeupd0qEzi73Unk1yPqau3s2gBvVBoAUKiRjd6k
         KPJcnnQjweZEnY0ZKNg+Hwh/3fa7dw9suM6WY=
Message-ID: <3aaafc130812021659x36701b19vc0d22f3c38471b65@mail.gmail.com>
Date: Tue, 2 Dec 2008 19:59:57 -0500
From: "J.R. Mauro" <jrm8005@gmail.com>
To: "Gerd Hoffmann" <kraxel@redhat.com>
Subject: Re: In-kernel IR remote control support
Cc: "Christoph Bartelmus" <lirc@bartelmus.de>, pavel@suse.cz,
       jonsmirl@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <4935B00D.5010302@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <AqQThtpZjFB@christoph> <4935B00D.5010302@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2008 at 5:00 PM, Gerd Hoffmann <kraxel@redhat.com> wrote:
>  Hi,
>
>>> Can we merge the common ones into the kernel, while still keeping the
>>> obscure ones in userspace using uinput or something?
>>
>> Why do you want to complicate things even more.
>
> Reality check please.  It already is that complicated.  We have IR
> kernel drivers today.
>
>> The decision to include some IR support using the Linux input layer some
>> time ago has forced *me* to add support for this in LIRC and explain to
>> people why for some devices they need LIRC drivers, and for some they need
>> the kernel drivers, and for other configurations they have to explicitly
>> disable the kernel drivers and replace them by LIRC drivers, etc.
>
> The only way to get out of this situation long-term is to get advanced
> IR support into the mainline kernel.

We at least need a unified place for drivers, or unified support for
those drivers that must be put in userspace, a la usbfs and libusb.

>
> It doesn't matter how that actually looks like.  Could be pretty much
> like todays lirc drivers.  Could be some input layer extention for
> receiving/sending raw IR codes.  Could be something completely different
> such as using the tty layer for that.  That has to be discussed and
> agreed on.

Agreed. And we need to make sure the discussion part actually happens
because once a decision is made, it's hard to correct bad choices.

I would think that an input layer extension would be best because,
e.g. Apple remotes are changed around all the time and, while
functioning the same and having the same form, they send very very
slightly different codes, and I think we would want a way to keep this
really flexible so we just update a quirks table or something to that
effect. I don't know if we're already trying to do that (if we are,
hooray, I'll go away now) but I think it's a good idea.

>
> What *does* matter is being in mainline.  lirc not being in mainline was
> *the* major reason for me to use the input layer to handle TV card IR
> support.  Having a in-tree driver depending on a out-of-tree subsystem
> for IR is a major pain.
>
> It is certainly a good thing to have only *one* way to handle IR
> remotes.  But the kernel side of that way *must* be in mainline.
> Everything else simply isn't going to fly.

One way or a hybrid way to address everyone's concerns. I don't see
why this has to be ALL kernel or ALL userspace. I would think it could
be both and still be clean.

>
> cheers,
>  Gerd
>
>
>
