Return-Path: <linux-kernel-owner+w=401wt.eu-S1946111AbXBPUdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946111AbXBPUdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946135AbXBPUdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:33:11 -0500
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:45727 "EHLO
	netops-testserver-4.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946111AbXBPUdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:33:10 -0500
Date: Fri, 16 Feb 2007 12:33:08 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 07/21] Xen-paravirt: remove ctor for pgd cache
In-Reply-To: <20070216022531.047039320@goop.org>
Message-ID: <Pine.LNX.4.64.0702161229360.26650@schroedinger.engr.sgi.com>
References: <20070216022449.739760547@goop.org> <20070216022531.047039320@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Jeremy Fitzhardinge wrote:

> Remove the ctor for the pgd cache.  There's no point in having the
> cache machinery do this via an indirect call when all pgd are freed in
> the one place anyway.

Great. We finally get rid of this evil ..... 

On second throughts:

Are you sure that you understand what you are modifying? The ctor is not 
called when you allocate an object but when the slab allocates it. Freeing 
an object does not make the slab free it. It will hold it for the next
kmalloc. So you may just have reduced performance somewhat by addiung 
additional ctor processing and possibly disturbed the preservation of 
cache hot pgds.

