Return-Path: <linux-kernel-owner+w=401wt.eu-S1752975AbXBJDpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975AbXBJDpo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 22:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXBJDpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 22:45:44 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:52480 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975AbXBJDpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 22:45:44 -0500
Date: Fri, 9 Feb 2007 22:45:41 -0500 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@d.namei
To: Rusty Russell <rusty@rustcorp.com.au>
cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization <virtualization@lists.osdl.org>
Subject: Re: [PATCH 4 of 7]  lguest: Config and headers
In-Reply-To: <1171064515.15356.10.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702092243170.13855@d.namei>
References: <1171033146.2718.157.camel@localhost.localdomain> 
 <1171033383.2718.163.camel@localhost.localdomain> 
 <1171033436.2718.165.camel@localhost.localdomain> 
 <1171033484.2718.167.camel@localhost.localdomain> 
 <1171033741.2718.172.camel@localhost.localdomain>  <Pine.LNX.4.64.0702091304090.9927@d.namei>
 <1171064515.15356.10.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Feb 2007, Rusty Russell wrote:

> Well it was the use of get_order() which triggered Andi's alarm bells,
> so I went back to deriving it.  This code is correct, however.

+       hype_pages = alloc_pages(GFP_KERNEL|__GFP_ZERO, HYPERVISOR_MAP_ORDER);
+       if (!hype_pages)
+               return -ENOMEM;

This will try and allocate 2^16 pages.  I guess we need a 
HYPERVISOR_PAGE_ORDER ?


- James
-- 
James Morris
<jmorris@namei.org>
