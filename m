Return-Path: <linux-kernel-owner+w=401wt.eu-S1751384AbYE1NNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384AbYE1NNN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 09:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750760AbYE1NNB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 09:13:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbYE1NNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 09:13:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0805221907250.4056@sbz-30.cs.Helsinki.FI>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: dhowells@redhat.com, clameter@sgi.com, mpm@selenic.com,
       lethal@linux-sh.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 28 May 2008 14:12:35 +0100
Message-ID: <2874.1211980355@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka J Enberg <penberg@cs.helsinki.fi> wrote:

> From: Christoph Lameter <clameter@sgi.com>
> 
> As reported by Paul Mundt, kobjsize() does not work properly with SLOB and SLUB
> that re-use parts of struct page for their own purposes. Fix it up by using
> compound_order() for compound pages that don't have PageSlab set.
> 
> Reported-by: Paul Mundt <lethal@linux-sh.org>
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
> I kept the original object size calculation for non-compound pages in this 
> version. It looks like the nommu code uses kobjsize() for all sorts of 
> interesting things.

Works for SLAB and SLUB.  SLOB breaks well before getting to anything these
patches affect.

Acked-by: David Howells <dhowells@redhat.com>
