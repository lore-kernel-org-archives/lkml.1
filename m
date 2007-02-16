Return-Path: <linux-kernel-owner+w=401wt.eu-S932394AbXBPPmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394AbXBPPmk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 10:42:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932417AbXBPPmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 10:42:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:54053 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932394AbXBPPmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 10:42:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pQh/smdZP17lAyGPjpKwWKrdbvzEyrd8rpkJupIKa+c7Zztnp06fKE3z5P6TruRAvEnFcXm1mF8VHKlYvND0+Il44xQO/PK4aunnKiV47S6tbxIkbhH6PUNZj9We65UaHr0et9BRSYnNCo7okMaxksiNulRETLB8OlWMJytLuC4=
Message-ID: <d120d5000702160742v14ac197eica567a15cc1e85d4@mail.gmail.com>
Date: Fri, 16 Feb 2007 10:42:37 -0500
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andres Salomon" <dilinger@debian.org>
Subject: Re: [patch 1/3] Input: psmouse - create PS/2 protocol options for Kconfig
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <45D54260.7080302@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45D43115.6060806@debian.org> <45D50101.60802@debian.org>
	 <20070215173024.adc54d6c.akpm@linux-foundation.org>
	 <200702160028.09251.dtor@insightbb.com> <45D54260.7080302@debian.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/16/07, Andres Salomon <dilinger@debian.org> wrote:
> Dmitry Torokhov wrote:
> > On Thursday 15 February 2007 20:30, Andrew Morton wrote:
> >> On Thu, 15 Feb 2007 19:55:29 -0500
> >> Andres Salomon <dilinger@debian.org> wrote:
> [...]
> >> Perhaps a nicer implementation would be to have a separate .c file for each
> >> variant.
> >>
> >
> > Having completely separate sub-drivers is very hard because of very delicate
> > PS/2 protocol probing....
> >
> > What do you think about patch below? It somewhat reduces #ifdef clutter in main
> > module moving it in .h files...
> >
>
> Normally, I'm a fan of that sort of thing.  However, in this case, I
> think it makes sense to have the #ifdefs right in the probe function; at
> least for me, it makes it easier to understand what's going on.  The
> synaptics stuff is especially tricky; with a cursory glance over the
> code, one might assume that all the synaptics functions disappear when
> CONFIG_MOUSE_PS2_SYNAPTICS is unset.  However, if the #ifdef's are in
> the probe function, it's pretty clear that some synaptics functions
> still get called even when CONFIG_MOUSE_PS2_SYNAPTICS is unset.
>

Thit is a valid point but #ifdef maze in the middle of already messy
psmouse-extensions() is too much for me. I guess I will just add a
comment explaining that synaptics probing is really special.

Btw, can I get that OLPC patch when you have time?

-- 
Dmitry
