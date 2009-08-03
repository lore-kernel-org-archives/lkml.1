Return-Path: <linux-kernel-owner+w=401wt.eu-S932229AbZHCO4u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932229AbZHCO4u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 10:56:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932213AbZHCO4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 10:56:50 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:38065 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932208AbZHCO4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 10:56:49 -0400
Date: Mon, 3 Aug 2009 10:56:42 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [patch] slub: use size and objsize orders to disable debug
 flags
In-Reply-To: <alpine.DEB.2.00.0907271830010.7634@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0908031054180.22135@gentwo.org>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org> <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271740090.27697@gentwo.org>
 <alpine.DEB.2.00.0907271533070.23587@chino.kir.corp.google.com> <alpine.DEB.2.00.0907271830010.7634@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Christoph Lameter <cl@linux-foundation.org>

On Mon, 27 Jul 2009, David Rientjes wrote:
> @@ -2488,6 +2474,18 @@ static int kmem_cache_open(struct kmem_cache *s, gfp_t gfpflags,
>
>  	if (!calculate_sizes(s, -1))
>  		goto error;
> +	if (disable_higher_order_debug) {
> +		/*
> +		 * Disable debugging flags that store metadata if the min slab
> +		 * order increased.
> +		 */
> +		if (get_order(s->size) > get_order(s->objsize)) {
> +			s->flags &= ~DEBUG_METADATA_FLAGS;

> +			s->offset = 0;

Hmmm... Move this line into calculate_sizes()?

