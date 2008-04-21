Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbYDUVEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbYDUVEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 17:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYDUVDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 17:03:38 -0400
Received: from rv-out-0708.google.com ([209.85.198.244]:43045 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752402AbYDUVDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ciofVIjIHO+IeqDSJRYuOU/R6LxP7w4YnhTktOfWv6S88U3tLqxkczUSjKEaauIsbBvw0xJ0s94Ma+eizlp2viwYwx9BjkpbLcri2ID1A2mm3/yF3lEXdIK54ftzhG+jD10lk14zHmxgEXmtddbjfc60uD5jGlz25JrmuqVSt1I=
Message-ID: <86802c440804211403x2f6a3989w7f691be4cf0071b9@mail.gmail.com>
Date: Mon, 21 Apr 2008 14:03:35 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: Alan <alan@clueserver.org>, "Andi Kleen" <andi@firstfloor.org>,
       "Ingo Molnar" <mingo@elte.hu>
Subject: Re: Aperture memory hole on x86_64
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <2615.198.182.194.170.1208810542.squirrel@clueserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48738.12.172.32.236.1208805186.squirrel@clueserver.org>
	 <86802c440804211232q39b35837ob50674718c617348@mail.gmail.com>
	 <2615.198.182.194.170.1208810542.squirrel@clueserver.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 1:42 PM, Alan <alan@clueserver.org> wrote:
>
> > On Mon, Apr 21, 2008 at 12:13 PM, Alan <alan@clueserver.org> wrote:
>  >> Something I noticed on my new AMD64 laptop with 4 gigs of RAM and a
>  >> 256meg
>  >>  video card.
>  >>
>  >>  I am running 2.6.25 from Fedora 9 beta.
>  >>
>  >>  When i boot, I get the following messages:
>  >>
>  >>  Checking aperture...
>  >>  Node 0: aperture @ 9816000000 size 32 MB
>  >>  Aperture beyond 4GB. Ignoring.
>  >>  No AGP bridge found
>  >>  Your BIOS doesn't leave a aperture memory hole
>  >>  Please enable the IOMMU option in the bios setup
>  >>  Mapping aperture over 65536 KB of RAM @ c000000
>  >>
>  >>  Is this a bug or is the x86_64 supposed to map the video aperture into
>  >>  something that is 32bit addressable?
>  >>
>  >>  Also, there is no video settings at all on this particular laptop in
>  >> bios.
>  >>   (It is an HP dv6700 with almost everything maxed out.)
>  >>
>  >>  Just curious if this is correct behavior or not. (Since I am using the
>  >>  xorg nv driver, it may not make any difference.)
>  >
>  > you have 4G ram installed, and hw mem hole is enabled, so you memory
>  > top is above 4g.
>  > and kernel need to use gart for iommu.
>  >
>  > and you bios didn't setup your gart because you didn't have agp..
>  >
>  > please check if you BIOS have setup for gart, and you can set size to
>  > 64M, and then you could get 64M ram back.
>
>  There is no memory or video related setting options in the bios at all.
>  It is about as barebones as you can get.
>
>  If you want, I can send the output of dmesg or other diagnostics for this
>  machine.

that is ok.

because get that from RAM is safe.

or some day we can treat GART in amd NB as unassigned resource, and
assign some mmio resource to it...
so you can get 64M back. --- but that not 100% safe.

YH
