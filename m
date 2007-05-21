Return-Path: <linux-kernel-owner+w=401wt.eu-S1756627AbXEUHZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756627AbXEUHZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 03:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754911AbXEUHYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 03:24:54 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:21778 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbXEUHYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 03:24:53 -0400
Date: Mon, 21 May 2007 09:24:49 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, "NeilBrown" <neilb@suse.de>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "linux-s390" <linux-s390@vger.kernel.org>
Subject: Re: 2.6.22-rc1-mm1 - s390 vs. md
Message-ID: <20070521092449.34a50f2e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <0C7297FA1D2D244A9C7F6959C0BF1E5201DEA930@azsmsx413.amr.corp.intel.com>
References: <20070518073946.716132f4@gondolin.boeblingen.de.ibm.com>
	<0C7297FA1D2D244A9C7F6959C0BF1E5201DEA930@azsmsx413.amr.corp.intel.com>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.12; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 May 2007 09:30:09 -0700,
"Williams, Dan J" <dan.j.williams@intel.com> wrote:

> When CONFIG_DMA_ENGINE=n async_tx_find_channel takes the form:
> ... async_tx_find_channel( ... )
> {
> 	return NULL;
> }
> 
> So in the S390 case the entire asynchronous path will be compiled away.

Unfortunately, do_async_xor() (and others) is not ifdef'ed and contains
dma_map_page(), which led to the compile failure...
