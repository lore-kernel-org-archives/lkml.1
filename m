Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbYJJDrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbYJJDrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 23:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbYJJDrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 23:47:33 -0400
Received: from gate.crashing.org ([63.228.1.57]:59273 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYJJDrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 23:47:33 -0400
Subject: Re: [PATCH 1/2] OF: new helper: of_parse_phandles_with_args()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
In-Reply-To: <20080925183710.GA25627@oksana.dev.rtsoft.ru>
References: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
	 <20080925183710.GA25627@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 14:37:29 +1100
Message-Id: <1223609849.8157.135.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	for (i = 0; i < list_cells; cur_index++) {
> +		const u32 *cells;
> +		const phandle *phandle;
> +
> +		phandle = list + i;
> +		args = phandle + 1;

Rather than incrementing i, I would just use a running pointer "list"
and drop "i" totally. Not big deal tho.

> +		/* one cell hole in the list = <>; */
> +		if (!*phandle) {
> +			if (cur_index == index)
> +				return -ENOENT;
> +			i++;
> +			continue;
> +		}

I don't totally understand the above. The 0 phandle terminates the list
or is just an empty slot in it ? In the later case, it might be more
readable to use goto to skip over down to the normal if (cur_index ==
index) break; and let it return via the normal if (!node) return -ENOENT
out of the loop.

Appart from that it's good and I'm fine with putting it in if you respin
despite being a bit late mostly because it's me who is later reviewing
there :-)

Cheers,
Ben.


