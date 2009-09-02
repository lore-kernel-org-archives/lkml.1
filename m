Return-Path: <linux-kernel-owner+w=401wt.eu-S1753089AbZIBR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbZIBR1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZIBR1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 13:27:01 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:60529 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752858AbZIBR1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 13:27:00 -0400
Subject: Re: [patch 1/2 -mm] flex_array: introduce DEFINE_FLEX_ARRAY
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0909012013180.13377@chino.kir.corp.google.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 10:26:42 -0700
Message-Id: <1251912402.12395.634.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-01 at 20:14 -0700, David Rientjes wrote:
> @@ -152,7 +136,8 @@ static unsigned int index_inside_part(struct
> flex_array *fa,
>  {
>         unsigned int part_offset;
> 
> -       part_offset = element_nr % __elements_per_part(fa->element_size);
> +       part_offset = element_nr %
> +                               FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size);
>         return part_offset * fa->element_size;
>  }

This all looks pretty good.  The only issue is that the macro name
lengths have gotten a bit out of hand.  

For instance.  This:

#define FLEX_ARRAY_ELEMENTS_PER_PART(size)                             \
       (FLEX_ARRAY_PART_SIZE / size)

ends up being longer in practice than just open-coding the operation:

	FLEX_ARRAY_ELEMENTS_PER_PART(fa->element_size)                      

vs.

	(FLEX_ARRAY_PART_SIZE / fa->element_size)

and the length also ends up making for a couple of pretty ugly line
wraps.

Otherwise, this is fine with me.

Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>

-- Dave

