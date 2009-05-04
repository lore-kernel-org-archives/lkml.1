Return-Path: <linux-kernel-owner+w=401wt.eu-S1754287AbZEDIF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287AbZEDIF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 04:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZEDIFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 04:05:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZEDIFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 04:05:09 -0400
Subject: Re: [PATCH] vmscan: evict use-once pages first (v2)
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>, elladan@eskimo.com,
       linux-kernel@vger.kernel.org, tytso@mit.edu,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org
In-Reply-To: <20090501123541.7983a8ae.akpm@linux-foundation.org>
References: <20090428044426.GA5035@eskimo.com>
	 <20090428192907.556f3a34@bree.surriel.com>
	 <1240987349.4512.18.camel@laptop>
	 <20090429114708.66114c03@cuia.bos.redhat.com>
	 <20090430072057.GA4663@eskimo.com>
	 <20090430174536.d0f438dd.akpm@linux-foundation.org>
	 <20090430205936.0f8b29fc@riellaptop.surriel.com>
	 <20090430181340.6f07421d.akpm@linux-foundation.org>
	 <20090430215034.4748e615@riellaptop.surriel.com>
	 <20090430195439.e02edc26.akpm@linux-foundation.org>
	 <49FB01C1.6050204@redhat.com>
	 <20090501123541.7983a8ae.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 04 May 2009 10:04:37 +0200
Message-Id: <1241424277.7620.4491.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-05-01 at 12:35 -0700, Andrew Morton wrote:

> No, I think it still _is_ the case.  When reclaim is treating mapped
> and non-mapped pages equally, the end result sucks.  Applications get
> all laggy and humans get irritated.  It may be that the system was
> optimised from an overall throughput POV, but the result was
> *irritating*.
> 
> Which led us to prefer to retain mapped pages.  This had nothing at all
> to do with internal impementation details - it was a design objective
> based upon empirical observation of system behaviour.

Shouldn't we make a distinction between PROT_EXEC and other mappings in
this? Because as soon as you're running an application that uses gobs
and gobs of mmap'ed memory, the mapped vs non-mapped thing breaks down.
