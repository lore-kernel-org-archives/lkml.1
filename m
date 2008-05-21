Return-Path: <linux-kernel-owner+w=401wt.eu-S933806AbYEUXrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806AbYEUXrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbYEUXrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:47:35 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:37007 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757019AbYEUXre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:47:34 -0400
Date: Thu, 22 May 2008 08:45:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, clameter@sgi.com, mpm@selenic.com,
       dhowells@redhat.com
Subject: Re: [RFC/PATCH 1/3] SLAB: Add PageSlab checking to ksize()
Message-ID: <20080521234555.GB32707@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	linux-kernel@vger.kernel.org, clameter@sgi.com, mpm@selenic.com,
	dhowells@redhat.com
References: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805212124250.22291@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 09:25:26PM +0300, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> The ksize() function is meant for objects allocated from the slab caches, not
> for arbitrary objects. Add a BUG_ON() to enforce that.
> 
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: David Howells <dhowells@redhat.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

This series seems to work ok with all of SLAB/SLUB/SLOB when also
applying the kobjsize() patch. Without the kobjsize() patch in place,
SLAB and SLUB both work, while SLOB still triggers the >= MAX_ORDER
BUG_ON() for page cache pages. Note that this is still an improvement
over SLUB blowing up, as it was before, even without the kobjsize()
change.
