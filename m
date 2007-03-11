Return-Path: <linux-kernel-owner+w=401wt.eu-S933842AbXCKQoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933842AbXCKQoY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 12:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933841AbXCKQoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 12:44:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:33966 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933838AbXCKQoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 12:44:22 -0400
Date: Sun, 11 Mar 2007 09:44:20 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andi Kleen <ak@suse.de>
cc: linux-kernel@vger.kernel.org, ak@suse.com, linux-ia64@vger.kernel.org,
       holt@sgi.com, mpm@selenic.com
Subject: Re: [QUICKLIST 4/6] x86_64: Single Quicklist
In-Reply-To: <200703110854.05799.ak@suse.de>
Message-ID: <Pine.LNX.4.64.0703110939140.24216@schroedinger.engr.sgi.com>
References: <20070311020923.19905.49260.sendpatchset@schroedinger.engr.sgi.com>
 <20070311020944.19905.87599.sendpatchset@schroedinger.engr.sgi.com>
 <200703110854.05799.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Mar 2007, Andi Kleen wrote:

> This and i386 version are ok to me, although it might be better to just
> finish __GFP_ZERO support to do this.

This would not work for pgds on i386 and x86_64

GFP_ZERO support the way I have done it in the past would mean another set 
of buddy lists in the page allocator and another issue with fragmentation. 
So I have stayed away from it although patches exist in my archives (See 
my ftp.kernel.org archive).

Maybe we could implemento limited GFP_ZERO support by just keeping an 
additional per cpu list of pages? The issue with that one is that a page
may grow cold on that list. One usually want the page to be hot in the 
cache when it is allocated. This is different for page table pages. Page 
table pages are typically sparsely accessed.
