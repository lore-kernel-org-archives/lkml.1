Return-Path: <linux-kernel-owner+w=401wt.eu-S933054AbXF2FFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933054AbXF2FFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2007 01:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXF2FFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jun 2007 01:05:47 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50508
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbXF2FFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2007 01:05:47 -0400
Date: Thu, 28 Jun 2007 22:06:06 -0700 (PDT)
Message-Id: <20070628.220606.112621271.davem@davemloft.net>
To: clameter@sgi.com
Cc: hugh@veritas.com, James.Bottomley@steeleye.com, rmk+lkml@arm.linux.org.uk,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Containment measures for slab objects on scatter
 gather lists
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0706282119330.11676@schroedinger.engr.sgi.com>
	<20070628.212825.78710369.davem@davemloft.net>
	<Pine.LNX.4.64.0706282128570.11739@schroedinger.engr.sgi.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <clameter@sgi.com>
Date: Thu, 28 Jun 2007 21:39:01 -0700 (PDT)

> Hmmmm... Maybe we are creating more of a mess with this. Isnt there some 
> other way to handle these object.

That's where I was going with the silly idea to use another
allocator :)

Really, it would be great if we could treat kmalloc() objects
just like real pages.  Everything wants to do I/O on pages
but sometimes (like the networking) you have a kmalloc
chunk which is technically just a part of a page.

The fact that there is no easy way to make this work is
frustrating :-)
