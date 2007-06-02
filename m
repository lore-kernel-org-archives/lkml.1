Return-Path: <linux-kernel-owner+w=401wt.eu-S1759550AbXFBDmG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759550AbXFBDmG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 23:42:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755252AbXFBDl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 23:41:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53853 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbXFBDl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 23:41:56 -0400
Date: Fri, 1 Jun 2007 20:41:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       jeremy@goop.org
Subject: Re: SLUB: Return ZERO_SIZE_PTR for kmalloc(0)
Message-Id: <20070601204141.f84ad72f.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706011831170.10767@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 1 Jun 2007 18:37:46 -0700 (PDT) Christoph Lameter <clameter@sgi.com> wrote:
>
> +#define ZERO_SIZE_PTR ((void *)16)

Jeremy's point was a good one.  The kernel _does_ use address-comparison
to determine object-inequality in an unknown but non-zero number of places.

It is of course unlikely that this will occur in conjunction with zero-sized
objects, but who knows?
