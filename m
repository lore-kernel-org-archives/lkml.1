Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbYJMADo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbYJMADo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 20:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754211AbYJMADh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 20:03:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:58108 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbYJMADg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 20:03:36 -0400
Subject: Re: [PATCH 1/2 v2] OF: new helper: of_parse_phandles_with_args()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: avorontsov@ru.mvista.com
Cc: linuxppc-dev@ozlabs.org, David Brownell <dbrownell@users.sourceforge.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Li Yang <leoli@freescale.com>, Timur Tabi <timur@freescale.com>
In-Reply-To: <20081010144317.GA2634@oksana.dev.rtsoft.ru>
References: <20080925183641.GA20037@oksana.dev.rtsoft.ru>
	 <20080925183710.GA25627@oksana.dev.rtsoft.ru>
	 <1223609849.8157.135.camel@pasglop>
	 <20081010144317.GA2634@oksana.dev.rtsoft.ru>
Content-Type: text/plain
Date: Mon, 13 Oct 2008 10:31:23 +1100
Message-Id: <1223854283.8157.202.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 18:43 +0400, Anton Vorontsov wrote:
> The helper is factored out of of_get_gpio(). Will be used by the QE
> pin multiplexing functions (they need to parse the gpios = <> too).
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

> +	while (list < list_end) {
> +		const u32 *cells;
> +		const phandle *phandle;
> +
> +		phandle = list;
> +		args = list + 1;
> +
> +		/* one cell hole in the list = <>; */
> +		if (!*phandle) {
> +			list++;
> +			goto next;
> +		}

Allright. I'll merge it. It might have been nicer to write here

		phandle = list++;
		args = list;

		if (!*phandle)
			goto next;

		.../...

		list += *cells;

But it's not big deal, I'll merge it as-is and if you feel like it
you can aways submit a cleanup later. In fact you can even completely
drop "args" I think.

Cheers,
Ben.


