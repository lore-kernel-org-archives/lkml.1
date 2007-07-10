Return-Path: <linux-kernel-owner+w=401wt.eu-S1759622AbXGJF4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759622AbXGJF4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 01:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbXGJF4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 01:56:36 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:41043 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbXGJF4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 01:56:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lDcQeDrQnH38vwb4MaM4MPYgW3QG2744J7DBM2x53/hHfsiQUdgGdw9piT92dOtOxE8njOT050Y6efGv3HciC/ymXcMavnQe/xpmCdTvc0WBpnPQbFqonOFcdMIqC/F1Z8hrDFtMGWFB8fHQSw64cwYhCSGsEinAhemDKxKju9M=
Message-ID: <41840b750707092256i280b6f00oac7b25004bf27bea@mail.gmail.com>
Date: Tue, 10 Jul 2007 01:56:34 -0400
From: "Shem Multinymous" <multinymous@gmail.com>
To: "Dmitry Torokhov" <dtor@insightbb.com>
Subject: Re: [Hdaps-devel] [PATCH] hdaps - switch to using input-polldev
Cc: hdaps-devel@lists.sourceforge.net, rlove@rlove.org,
       "Linux Kernel ML" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@osdl.org>, "Michael Riepe" <michael@mr511.de>,
       "Henrique de Moraes Holschuh" <hmh@debian.org>
In-Reply-To: <200707092358.08529.dtor@insightbb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705252354.43730.dtor@insightbb.com>
	 <200707090144.45557.dtor@insightbb.com>
	 <41840b750707082306n6509ee6ds3a0ccd16b6387353@mail.gmail.com>
	 <200707092358.08529.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/9/07, Dmitry Torokhov <dtor@insightbb.com> wrote:
> > Sounds good, then. It's a bit of a hack, but the benefits are well
> > worth it (if we can resolve the scheduling issue).
>
> You know, I slept on it and I think I want to move the polldev into
> opposite direction - to accomodte devices that need "relaxed" polling
> and are ok with polling being a bit irregular and maybe even rounded
> to next jiffy or something to better accomodate tickless kernels.

How about letting drivers and/or clients explicitly express their
scheduling needs, e.g., in terms of a desired polling rate and a
desired bound on scheduling irregularity? Given these requirements,
input-polldev will try to satisfy all requests (i.e., the harshest
one) made by the driver and current clients, on a "best effort" basis,
using minimal resources. (There should also be a way for a driver to
say "don't bother to poll more often than X or with regularity better
than Y even if a client asks for it -- the hardware isn't that fast
anyway".)

This way the same infrastructure could smoothly handle devices and
apps with vastly different polling needs.

That doesn't help much with the workqueue vs. timers issue, of course,
unless input-polldev implements *both*.

  Shem
