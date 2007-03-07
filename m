Return-Path: <linux-kernel-owner+w=401wt.eu-S1422967AbXCGSB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422967AbXCGSB7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 13:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422766AbXCGSBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 13:01:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:46116 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422889AbXCGSBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 13:01:14 -0500
Date: Wed, 7 Mar 2007 10:00:41 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Nick Piggin <npiggin@suse.de>, Miklos Szeredi <miklos@szeredi.hu>,
       akpm@linux-foundation.org, mingo@elte.hu, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       Jeff Dike <jdike@addtoit.com>, hugh <hugh@veritas.com>
Subject: Re: [RFC][PATCH] mm: fix page_mkclean() vs non-linear vmas
In-Reply-To: <1173286682.6374.191.camel@twins>
Message-ID: <Pine.LNX.4.64.0703070959430.5963@woody.linux-foundation.org>
References: <1173264462.6374.140.camel@twins>  <20070307110035.GE5555@wotan.suse.de>
 <1173268086.6374.157.camel@twins>  <20070307121730.GC18704@wotan.suse.de>
 <1173271286.6374.166.camel@twins>  <20070307130851.GE18704@wotan.suse.de>
 <1173273562.6374.175.camel@twins>  <20070307133649.GF18704@wotan.suse.de>
 <1173275532.6374.183.camel@twins>  <1173278067.6374.188.camel@twins> 
 <20070307150102.GH18704@wotan.suse.de> <1173286682.6374.191.camel@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 Mar 2007, Peter Zijlstra wrote:
> 
> I'm not at all happy with this, but plain disallowing remap_file_pages on bdis
> without BDI_CAP_NO_WRITEBACK seems to offend some people, hence restrict it to
> root only.

I don't think that's a viable approach. Nonlinear mappings would normally 
be used by databases, and you don't want to limit databases to be run by 
root only.

		Linus
