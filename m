Return-Path: <linux-kernel-owner+w=401wt.eu-S1760611AbXENGQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611AbXENGQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 02:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbXENGQc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 02:16:32 -0400
Received: from ik-out-1112.google.com ([66.249.90.180]:37278 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757289AbXENGQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 02:16:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:reply-to:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=fJHBe6C04SqSSwxMkiKzZgt3kOPkpSJvoRRzmg8jiorzbT19uXULpeBnGZUGz9L4NTGFIEK654Yd/X4LEArK+SssJswC3DTWlO6b9+9Nb4yqBIJrOsS7gRozyBueHcw2PSUcYj/99ykOwvCOJP10/bIx2wuBUutHfxDN43iGlRk=
Message-ID: <929318d30705132316w300fe8e4ue98a02e85cd82cfb@mail.gmail.com>
Date: Mon, 14 May 2007 08:16:29 +0200
From: "Giel de Nijs" <giel@caffeinetrip.com>
Reply-To: giel@caffeinetrip.com
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [patch 0/2] [PATCH] input: correctly handle keys without hardware release event
Cc: linux-kernel@vger.kernel.org, "Vojtech Pavlik" <vojtech@suse.cz>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Matt Domsch" <matt_domsch@dell.com>,
       "Rezwanul Kabir" <rezwanul_kabir@dell.com>,
       linux-input@atrey.karlin.mff.cuni.cz
In-Reply-To: <200705132344.19311.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070511172326.008944330@caffeinetrip.com>
	 <200705132344.19311.dtor@insightbb.com>
X-Google-Sender-Auth: b2cac5bd981cf8f3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/14/07, Dmitry Torokhov <dtor@insightbb.com> wrote:

> > This patch adds a soft release key mask to input_dev, to enable keyboard
> > drivers to determine which keys never generate a hardware release event and
> > hence add a release event after every press event of such keys. The mask is
> > controlled by ioctls.
>
> I don't think we want to add all the infrastructure for the benefit of single
> driver. Can we add a quirk to atkbd and activate it based on DMI?

As the atkbd.c driver already had a work-around for exactly the same problem
with some (I think) Korean keyboards (KEY_HANGEUL and KEY_HANJA), adding
this infrastructure (well, one pointer and two ioctls) seemed a logical step.
If you prefer a hack just in atkbd.c and activate it on Dell laptops, I see
what I can do. The problem with that is that I don't know the scancodes of
all keys on all models (and future models) that exhibit this behaviour. I'll
implement what I know, though (it'll take some time because I'll be
travelling quite a lot very soon).

Greetings,
Giel
