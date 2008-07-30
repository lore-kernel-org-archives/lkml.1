Return-Path: <linux-kernel-owner+w=401wt.eu-S1758222AbYG3R2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222AbYG3R2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 13:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbYG3R2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 13:28:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbYG3R2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 13:28:39 -0400
Date: Wed, 30 Jul 2008 10:28:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 1/2] Export get_user_pages_fast
Message-Id: <20080730102817.c74a9e33.akpm@linux-foundation.org>
In-Reply-To: <20080730171845.GB28604@cs181140183.pp.htv.fi>
References: <200807301438.55941.rusty@rustcorp.com.au>
	<20080730033523.0f38f7e4.akpm@linux-foundation.org>
	<20080730154736.GC21597@cs181140183.pp.htv.fi>
	<20080730100355.f1402dcf.akpm@linux-foundation.org>
	<20080730170939.GA28604@cs181140183.pp.htv.fi>
	<20080730101438.e1484440.akpm@linux-foundation.org>
	<20080730171845.GB28604@cs181140183.pp.htv.fi>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008 20:18:45 +0300 Adrian Bunk <bunk@kernel.org> wrote:

> > > The export would still only be available on x86 since no other arch 
> > > would define CONFIG_HAVE_GET_USER_PAGES_FAST.
> > > 
> > 
> > That's presently true in Linus mainline.  The powerpc implementation is
> > in -mm, but apprarently needs a bit more work.
> 
> I still don't get the advantage of your suggestion.
> 
> With the powerpc implementation included your suggestion doesn't change 
> the fact that the export is available only on x86 and powerpc, and if a 
> driver author mistakenly uses it and only tests it's driver on x86 it 
> will still break on architectures other than x86 or powerpc.

On non-CONFIG_HAVE_GET_USER_PAGES_FAST architectures a
get_user_pages_fast() call will in fact call get_user_pages().

On CONFIG_HAVE_GET_USER_PAGES_FAST architectures, get_user_pages_fast()
is a real function.  All architectures which implement that function
should export it to modules.  Hence it should be exported from within
generic code.
