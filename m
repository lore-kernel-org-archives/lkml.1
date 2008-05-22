Return-Path: <linux-kernel-owner+w=401wt.eu-S1752107AbYEVEPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbYEVEPl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 00:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYEVEPd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 00:15:33 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:40058 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYEVEPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 00:15:32 -0400
Message-ID: <4834F2E2.3070806@cs.helsinki.fi>
Date: Thu, 22 May 2008 07:13:22 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org, clameter@sgi.com, mpm@selenic.com,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI> <20080521234555.GB32707@linux-sh.org>
In-Reply-To: <20080521234555.GB32707@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mundt wrote:
> This series seems to work ok with all of SLAB/SLUB/SLOB when also
> applying the kobjsize() patch. Without the kobjsize() patch in place,
> SLAB and SLUB both work, while SLOB still triggers the >= MAX_ORDER
> BUG_ON() for page cache pages. Note that this is still an improvement
> over SLUB blowing up, as it was before, even without the kobjsize()
> change.

That's probably due to the fact that we use PageSlab for all pages with 
SLUB and for bigblock pages in SLOB with this patch. Christoph, Matt, 
any suggestions how to fix the PageSlab check in nommu btw?

		Pekka
