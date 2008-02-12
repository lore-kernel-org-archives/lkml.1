Return-Path: <linux-kernel-owner+w=401wt.eu-S1754871AbYBLV5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbYBLV5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 16:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751441AbYBLV5W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 16:57:22 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36599 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799AbYBLV5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 16:57:21 -0500
Subject: Re: [-mm PATCH] register_memory/unregister_memory clean ups
From: Dave Hansen <haveblue@us.ibm.com>
To: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, greg@kroah.com,
       linux-mm <linux-mm@kvack.org>
In-Reply-To: <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
References: <20080211114818.74c9dcc7.akpm@linux-foundation.org>
	 <1202765553.25604.12.camel@dyn9047017100.beaverton.ibm.com>
	 <20080212154309.F9DA.Y-GOTO@jp.fujitsu.com>
	 <1202836953.25604.42.camel@dyn9047017100.beaverton.ibm.com>
	 <1202849972.11188.71.camel@nimitz.home.sr71.net>
	 <1202853415.25604.59.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain
Date: Tue, 12 Feb 2008 13:57:14 -0800
Message-Id: <1202853434.11188.76.camel@nimitz.home.sr71.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-02-12 at 13:56 -0800, Badari Pulavarty wrote:
> 
> +static void __remove_section(struct zone *zone, unsigned long
> section_nr)
> +{
> +       if (!valid_section_nr(section_nr))
> +               return;
> +
> +       unregister_memory_section(__nr_to_section(section_nr));
> +       sparse_remove_one_section(zone, section_nr);
> +}

I do think passing in a mem_section* here is highly superior.  It makes
it impossible to pass a pfn in and not get a warning.

-- Dave

