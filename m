Return-Path: <linux-kernel-owner+w=401wt.eu-S1753354AbYCCNxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbYCCNxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 08:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753461AbYCCNxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 08:53:21 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:4351 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753079AbYCCNxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 08:53:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=xhas/Kurh+PTV8bcVhPBr7LjxZtRvMMa9o2ePPifKmryJVkw+ek3bw+DvVG4JhWKaRyCv2NcgY+EqbP9aKjjk35GqtR1x1RiEJE3mcb4wPD6gFIkY6QK3elE9ReU8F6NI30iOAn7LpglwJjmCm2VP2e4JFR66gqTMxQmFc1Y2kg=
Message-ID: <84144f020803030553s35a40dd8yf88585ccd5a599fd@mail.gmail.com>
Date: Mon, 3 Mar 2008 15:53:15 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Nick Piggin" <npiggin@suse.de>
Subject: Re: [rfc][patch 3/3] use SLAB_ALIGN_SMP
Cc: "Eric Dumazet" <dada1@cosmosbay.com>, netdev@vger.kernel.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, "David Miller" <davem@davemloft.net>,
       "Christoph Lameter" <clameter@engr.sgi.com>
In-Reply-To: <20080303134622.GD13138@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080303093449.GA15091@wotan.suse.de>
	 <20080303093624.GC15091@wotan.suse.de>
	 <47CBCAB0.2040604@cosmosbay.com>
	 <20080303124142.GB13138@wotan.suse.de> <47CBF683.10201@cosmosbay.com>
	 <20080303134622.GD13138@wotan.suse.de>
X-Google-Sender-Auth: cc36e43dcdc8d867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 3, 2008 at 3:46 PM, Nick Piggin <npiggin@suse.de> wrote:
>  > Maybe we need to use three flags to separate the meanings ?
>  >
>  > SLAB_HINT_SMP_ALIGN
>  > SLAB_HINT_HWCACHE_ALIGN
>  > SLAB_HWCACHE_ALIGN /* strong requirement that two objects dont share a
>  > cache line */
>
>  Possibly, but I'm beginning to prefer that strong requirements should
>  request the explicit alignment (they can even use cache_line_size() after
>  Pekka's patch to make it generic). I don't like how the name implies
>  that you get a guarantee, however I guess in practice people are using it
>  more as a hint (or because they vaguely hope it makes their code run
>  faster :))

At least historically SLAB_HWCACHE_ALIGN has been just a hint,
although slab tries very hard to satisfy it (see the comments in
mm/slab.c). Why do we need stronger guarantees than that, btw?
