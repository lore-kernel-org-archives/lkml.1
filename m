Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbYDED17@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbYDED17 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 23:27:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751339AbYDED1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 23:27:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751331AbYDED1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 23:27:50 -0400
Date: Fri, 4 Apr 2008 20:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: "Kyungmin Park" <kmpark@infradead.org>, "Josh Boyer" <jwboyer@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       "Michael Trimarchi" <trimarchimichael@yahoo.it>,
       spi-devel-general@lists.sourceforge.net, dwmw2@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH] jffs2 summary allocation
Message-Id: <20080404202704.84e743d7.akpm@linux-foundation.org>
In-Reply-To: <200804041941.35075.david-b@pacbell.net>
References: <713171.37644.qm@web26213.mail.ukl.yahoo.com>
	<9c9fda240804041829r5a768b39n340926485aa12687@mail.gmail.com>
	<20080404184615.deaf3122.akpm@linux-foundation.org>
	<200804041941.35075.david-b@pacbell.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008 19:41:34 -0700 David Brownell <david-b@pacbell.net> wrote:

> On Friday 04 April 2008, Andrew Morton wrote:
> > This problem comes up pretty often. 
> 
> Which problem -- kmalloc(BIG)?  Or dma(dma-unsafe-mem)?
> Or something else?

Code needing a large amount of memory, trying to kmalloc it, then getting
into trouble, them using vmalloc, then getting into more trouble.

This is kernel - order-0 allocations will always be the most robust.
