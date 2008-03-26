Return-Path: <linux-kernel-owner+w=401wt.eu-S1760419AbYCZSHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760419AbYCZSHE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 14:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757956AbYCZSGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 14:06:51 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:10262 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757359AbYCZSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 14:06:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NpjDxtHfNTWAho7kNr5jakPAkHC7zOZeVLouW3v7ItmLC8hUXc/Z83e40Hs3PJYBvCzlqfBgxV1erjtHdMCBPrOD4FsnIvWNygArIMT2QuPbG49n4xVmMhRxzAZUHPu50u/3QSvgysZhEgcLJi6VbKygy9D44Yc4qKzh23PRjKE=
Message-ID: <a340dd0e0803261106v67bbecdaie8a3f52b47e2c84a@mail.gmail.com>
Date: Wed, 26 Mar 2008 14:06:49 -0400
From: "Mike Nuss" <mikenuss@gmail.com>
To: "Richard Kennedy" <richard@rsk.demon.co.uk>
Subject: Re: ohci : strange looking use of round_jiffies_relative. possible bug ?
Cc: "Alan Stern" <stern@rowland.harvard.edu>, dbrownell@users.sourceforge.net,
       linux-usb <linux-usb@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1206546405.2931.20.camel@castor.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.44L0.0803261136590.6324-100000@iolanthe.rowland.org>
	 <1206546405.2931.20.camel@castor.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2008 at 11:46 AM, Richard Kennedy
<richard@rsk.demon.co.uk> wrote:
>
>  On Wed, 2008-03-26 at 11:37 -0400, Alan Stern wrote:
>  > On Wed, 26 Mar 2008, Richard Kennedy wrote:
>  >
>  > > I was looking at the uses of round_jiffies and noticed that the ohci
>  > > unlink_watchdog_func() calls
>  > > mod_timer(&ohci->unlink_watchdog, round_jiffies_relative(HZ));
>  > >
>  > > Which looks a bit strange as it will set the timer to 0 <= t < HZ.
>  > > Reading the comments I think that is really is expecting to setup timer
>  > > to (now + 1s)
>  > >
>  > > mod_timer(&ohci->unlink_watchdog, round_jiffies(jiffies + HZ));
>  > >
>  > > If this is not true then perhaps it needs a comment to explain what it
>  > > _is_ trying to do, because it's got me baffled ;)

Yes, my intent there was a roughly 1 second delay. You're correct, it's wrong.

>  > I'd say it's a bug.  Or rather a pair of bugs, since that mod_timer()
>  > call appears in two places.

Yup.

Mike
