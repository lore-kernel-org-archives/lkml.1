Return-Path: <linux-kernel-owner+w=401wt.eu-S1758454AbYE1Cry@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758454AbYE1Cry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 22:47:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752678AbYE1Crq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 22:47:46 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:58215 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbYE1Crq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 22:47:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qHQ0wkTzaG7W68AdtEy3C4GDLg0huluEwzBOaucZLnMpxNpfWQ+xNg56EAk9u+PZl9qtVHV84Vw7jiyfWwmBGFDBjDtUb2qeV9RgTwOV7zt5+nK53P8osPfbfzaI1b2FnbRFTdxi1EWV/EatmBwdzu5P9/E+k7YB0gmwuhgShc0=
Message-ID: <412bdbff0805271947h23f71911vb8f13c76ffb7c6d2@mail.gmail.com>
Date: Tue, 27 May 2008 22:47:42 -0400
From: "Devin Heitmueller" <devin.heitmueller@gmail.com>
To: "Andy Walls" <awalls@radix.net>
Subject: Re: [PATCH] video4linux: Push down the BKL
Cc: "Mauro Carvalho Chehab" <mchehab@infradead.org>,
       "Alan Cox" <alan@redhat.com>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jonathan Corbet" <corbet@lwn.net>
In-Reply-To: <1211942221.3197.154.camel@palomino.walls.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080522223700.2f103a14@core>
	 <20080527094144.1189826a@bike.lwn.net>
	 <20080527133100.6a9302fb@gaivota>
	 <20080527103755.1fd67ec1@bike.lwn.net>
	 <20080527155942.7693c360@gaivota>
	 <412bdbff0805271226t41fe55b0jd0b8e3c737f34734@mail.gmail.com>
	 <20080527180048.6a27dbf7@gaivota>
	 <1211932138.3197.29.camel@palomino.walls.org>
	 <412bdbff0805271746x3db9ae28h3c0f0b565f50d4c6@mail.gmail.com>
	 <1211942221.3197.154.camel@palomino.walls.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Maybe return an EBUSY or E-something else for these cases when Myth
> tries to open() the second device node, when there's an underlying
> factor that requires things to be mutually exclusive.  Allowing things
> like read() to allow hardware mode switching between analog and digital
> seems like it could result in really weird behaviors at the application.

Pardon me for not being clear.  I wasn't suggesting having a mutex for
on the open call itself.  The mutex we have in the em28xx driver is
only in place when we are *switching* between modes.  The thinking was
to have open return EBUSY if the device is already in use in the other
mode, but we weren't sure if that would cause problems with MythTV
(since the open call would fail)  If MythTV can gracefully handle that
scenario, then that would be the ideal solution from a driver
perspective.

> But in this case I can't.  The driver probably shouldn't hold a lock and
> suspend an open() indefinitely (IMO).  It should say the device is BUSY
> as that is the truth: an underlying hardware device or resource is busy.

Yeah, this was just me not being clear.

-- 
Devin J. Heitmueller
http://www.devinheitmueller.com
AIM: devinheitmueller
