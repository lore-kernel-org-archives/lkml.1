Return-Path: <linux-kernel-owner+w=401wt.eu-S1752162AbXBDIQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbXBDIQo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 03:16:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbXBDIQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 03:16:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:47956 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbXBDIQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 03:16:43 -0500
Subject: Re: [RFC] Tracking mlocked pages and moving them off the LRU
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0702022214580.3960@schroedinger.engr.sgi.com>
	 <20070203005316.eb0b4042.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702030946330.5388@schroedinger.engr.sgi.com>
	 <1170525860.3073.1054.camel@laptopd505.fenrus.org>
	 <Pine.LNX.4.64.0702031055210.18224@schroedinger.engr.sgi.com>
	 <20070203172242.e5bf2534.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0702031744060.31986@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Sun, 04 Feb 2007 09:16:16 +0100
Message-Id: <1170576977.3073.1100.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Exclusion or inclusion of NR_MLOCK number is straightforward for the dirty 
> ratio calcuations. global_page_state(NR_MLOCK) f.e. would get us totals on 
> mlocked pages per zone. node_page_state(NR_MLOCK) gives a node specific 
> number of mlocked pages. The nice thing about ZVCs is that it allows
> easy access to counts on different levels.

however... mlocked pages still can be dirty, and want to be written back
at some point ;)

I can see the point of doing dirty ratio as percentage of the LRU size,
but in that case you don't need to track NR_MLOCK, only the total LRU
size. (And yes it'll be sometimes optimistic because not all mlock'd
pages are moved off the lru yet, but I doubt you'll have that as a
problem in practice)
-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

