Return-Path: <linux-kernel-owner+w=401wt.eu-S1759930AbYDUTc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbYDUTc4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755562AbYDUTcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:32:47 -0400
Received: from py-out-1112.google.com ([64.233.166.179]:31667 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYDUTcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:32:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=YxNUeaLyQthskpA1XrAeIvK9zZ53wEk3j/DAHR+qaY4LoOU3L3YSfbKhAeCe1b0qikgYGsLkkMR4jzqh2tMVnEUxwC7ik6oEZav7/+zLJFi7NpfcWl253TC9o24dt5/kou/FhgS7TMqOVu4g5PSFqAeZ/w47wyqNeleHU7hIUM8=
Message-ID: <86802c440804211232q39b35837ob50674718c617348@mail.gmail.com>
Date: Mon, 21 Apr 2008 12:32:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: Alan <alan@clueserver.org>
Subject: Re: Aperture memory hole on x86_64
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <48738.12.172.32.236.1208805186.squirrel@clueserver.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48738.12.172.32.236.1208805186.squirrel@clueserver.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2008 at 12:13 PM, Alan <alan@clueserver.org> wrote:
> Something I noticed on my new AMD64 laptop with 4 gigs of RAM and a 256meg
>  video card.
>
>  I am running 2.6.25 from Fedora 9 beta.
>
>  When i boot, I get the following messages:
>
>  Checking aperture...
>  Node 0: aperture @ 9816000000 size 32 MB
>  Aperture beyond 4GB. Ignoring.
>  No AGP bridge found
>  Your BIOS doesn't leave a aperture memory hole
>  Please enable the IOMMU option in the bios setup
>  Mapping aperture over 65536 KB of RAM @ c000000
>
>  Is this a bug or is the x86_64 supposed to map the video aperture into
>  something that is 32bit addressable?
>
>  Also, there is no video settings at all on this particular laptop in bios.
>   (It is an HP dv6700 with almost everything maxed out.)
>
>  Just curious if this is correct behavior or not. (Since I am using the
>  xorg nv driver, it may not make any difference.)

you have 4G ram installed, and hw mem hole is enabled, so you memory
top is above 4g.
and kernel need to use gart for iommu.

and you bios didn't setup your gart because you didn't have agp..

please check if you BIOS have setup for gart, and you can set size to
64M, and then you could get 64M ram back.

YH
