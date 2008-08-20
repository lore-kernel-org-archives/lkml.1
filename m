Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbYHTVxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbYHTVxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 17:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYHTVx2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 17:53:28 -0400
Received: from saeurebad.de ([85.214.36.134]:36836 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727AbYHTVx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 17:53:27 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Sean MacLennan <smaclennan@pikatech.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Section mismatch contig_page_data and bootmem_node_data
References: <20080820135551.74911cb3@lappy.seanm.ca>
Date: Wed, 20 Aug 2008 23:53:06 +0200
In-Reply-To: <20080820135551.74911cb3@lappy.seanm.ca> (Sean MacLennan's
	message of "Wed, 20 Aug 2008 13:55:51 -0400")
Message-ID: <87iqtv4am5.fsf@skyscraper.fehenstaub.lan>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Sean MacLennan <smaclennan@pikatech.com> writes:

> If CONFIG_NEED_MULTIPLE_NODES is *not* set, then you get a section
> mismatch in reference from the variable contig_page_data to the
> variable __initdata bootmem_node_data.
>
> The simple solution is to just remove the __initdata from
> bootmem_node_data. We could also put an ifdef around the __initdata.
>
> Signed-off-by: Sean MacLennan <smaclennan@pikatech.com>
> ---
> diff --git a/mm/bootmem.c b/mm/bootmem.c
> index e023c68..a968ae2 100644
> --- a/mm/bootmem.c
> +++ b/mm/bootmem.c
> @@ -31,7 +31,7 @@ unsigned long max_pfn;
>  unsigned long saved_max_pfn;
>  #endif
>  
> -bootmem_data_t bootmem_node_data[MAX_NUMNODES] __initdata;
> +bootmem_data_t bootmem_node_data[MAX_NUMNODES];

It is totally valid to be init data as it does not get referenced after
bootup and should therefor be freed.

The statically defined pointer from contig_page_data is the problem and
the fix should be on this end rather than worsening code to suppress a
warning.

NAK,

	Hannes
