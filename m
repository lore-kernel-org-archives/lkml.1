Return-Path: <linux-kernel-owner+w=401wt.eu-S934345AbYAaR07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934345AbYAaR07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 12:26:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759774AbYAaR0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 12:26:51 -0500
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:43631 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756136AbYAaR0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 12:26:50 -0500
Date: Thu, 31 Jan 2008 18:26:46 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       Herbert Xu <herbert@gondor.apana.org.au>, NeilBrown <neilb@suse.de>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: crypto/async_tx/* doesn't build on s390
Message-ID: <20080131182646.195990f7@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20080131145058.GA6789@osiris.boeblingen.de.ibm.com>
References: <20080131145058.GA6789@osiris.boeblingen.de.ibm.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008 15:50:58 +0100,
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> I get the following:
> 
> crypto/built-in.o: In function `do_async_xor':
> async_xor.c:49: undefined reference to `dma_map_page'
> async_xor.c:56: undefined reference to `dma_map_page'
> 
> This is mainly because s390 doesn't support DMA at all,
> but these files get selected via MD_RAID456 anyway.

deja-vu: http://marc.info/?l=linux-kernel&m=118056140212764&w=2

and indeed, async_memcpy.c doesn't seem to suffer from this affliction.
async_xor.c needs a similar treatment; maybe async_memset.c as well
(didn't check).

(No, I didn't actually look at the code :))
