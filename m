Return-Path: <linux-kernel-owner+w=401wt.eu-S1757840AbXJCIpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840AbXJCIpW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753608AbXJCIpK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:45:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:50801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900AbXJCIpJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:45:09 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH] mark read_crX() asm code as volatile
Date: Wed, 3 Oct 2007 10:45:05 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <cebbert@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Kirill Korotaev <dev@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
References: <470250E0.5090706@openvz.org> <4703342E.3020101@zytor.com> <200710030149.24914.nickpiggin@yahoo.com.au>
In-Reply-To: <200710030149.24914.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710031045.05234.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> 
> How does the compiler know it doesn't depend on memory?

When it has no m (or equivalent like g) constrained argument 
and no memory clobber.
 
> How do you say it depends on memory?

You add any of the above.

> You really need something as heavy as volatile?

You could do a memory clobber, but it would be heavier than the volatile
because the memory clobber clobbers all cached variables. volatile essentially 
just says "don't remove; has side effects". Normally gcc does that automatically
for something without outputs, but this one has.

Besides a CRx access does not actually clobber memory.

-Andi
