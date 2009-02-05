Return-Path: <linux-kernel-owner+w=401wt.eu-S1761607AbZBEBQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761607AbZBEBQ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 20:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754391AbZBEBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 20:16:18 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39494 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873AbZBEBQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 20:16:17 -0500
Date: Thu, 5 Feb 2009 10:15:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Swamy Gowda <swamy@virident.com>, linux-kernel@vger.kernel.org,
       Brice.Goglin@inria.fr, "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] release mmap_sem before starting migration (Was
 Re: Need to take mmap_sem lock in move_pages.
Message-Id: <20090205101503.b1fd7df6.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.1.10.0902041037150.19633@qirst.com>
References: <28631E6913C8074E95A698E8AC93D091B21561@caexch1.virident.info>
	<20090204183600.f41e8b7e.kamezawa.hiroyu@jp.fujitsu.com>
	<20090204184028.09a4bbae.kamezawa.hiroyu@jp.fujitsu.com>
	<20090204185501.837ff5d6.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.1.10.0902041037150.19633@qirst.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Feb 2009 10:39:19 -0500 (EST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Wed, 4 Feb 2009, KAMEZAWA Hiroyuki wrote:
> 
> > mmap_sem can be released after page table walk ends.
> 
> No. read lock on mmap_sem must be held since the migrate functions
> manipulate page table entries. Concurrent large scale changes to the page
> tables (splitting vmas, remapping etc) must not be possible.
> 
Just for clarification:

1. changes in page table is not problem from the viewpoint of kernel.
   (means no panic, no leak,...)
2. But this loses "atomic" aspect of migration and will allow unexpected
   behaviors.
   (means the page-mapping status after sys_move may not be what user expects.)


Thanks,
-Kame

