Return-Path: <linux-kernel-owner+w=401wt.eu-S2992428AbXCGSMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992428AbXCGSMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:12:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992431AbXCGSMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:12:36 -0500
Received: from amsfep17-int.chello.nl ([62.179.120.12]:20458 "EHLO
	amsfep17-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992428AbXCGSMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:12:34 -0500
Subject: Re: [RFC][PATCH] mm: fix page_mkclean() vs non-linear vmas
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Jeff Dike <jdike@addtoit.com>, hugh <hugh@veritas.com>
In-Reply-To: <Pine.LNX.4.64.0703070959430.5963@woody.linux-foundation.org>
References: <1173264462.6374.140.camel@twins>
	 <20070307110035.GE5555@wotan.suse.de> <1173268086.6374.157.camel@twins>
	 <20070307121730.GC18704@wotan.suse.de> <1173271286.6374.166.camel@twins>
	 <20070307130851.GE18704@wotan.suse.de> <1173273562.6374.175.camel@twins>
	 <20070307133649.GF18704@wotan.suse.de> <1173275532.6374.183.camel@twins>
	 <1173278067.6374.188.camel@twins>  <20070307150102.GH18704@wotan.suse.de>
	 <1173286682.6374.191.camel@twins>
	 <Pine.LNX.4.64.0703070959430.5963@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 19:12:00 +0100
Message-Id: <1173291120.4718.40.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 10:00 -0800, Linus Torvalds wrote:
> 
> On Wed, 7 Mar 2007, Peter Zijlstra wrote:
> > 
> > I'm not at all happy with this, but plain disallowing remap_file_pages on bdis
> > without BDI_CAP_NO_WRITEBACK seems to offend some people, hence restrict it to
> > root only.
> 
> I don't think that's a viable approach. Nonlinear mappings would normally 
> be used by databases, and you don't want to limit databases to be run by 
> root only.

It was claimed that they use it on tmpfs only, not on a 'real'
filesystem.

