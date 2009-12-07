Return-Path: <linux-kernel-owner+w=401wt.eu-S934935AbZLGJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbZLGJva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934900AbZLGJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:51:29 -0500
Received: from lo.gmane.org ([80.91.229.12]:37586 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934886AbZLGJv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:51:28 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Florian Mickler <florian@mickler.org>
Subject: Re: [022/119] highmem: Fix debug_kmap_atomic() to also handle
 KM_IRQ_PTE, KM_NMI, and KM_NMI_PTE
Date: Mon, 7 Dec 2009 10:50:34 +0100
Message-ID: <20091207105034.4dd2beac@schatten.dmk.lab>
References: <20091206235936.208334321@mini.kroah.org>
	<20091207000643.892734717@mini.kroah.org>
	<Pine.LNX.4.64.0912070105370.2642@sister.anvils>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-Gmane-NNTP-Posting-Host: f053213116.adsl.alicedsl.de
In-Reply-To: <Pine.LNX.4.64.0912070105370.2642@sister.anvils>
X-Newsreader: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Dec 2009 01:11:55 +0000 (GMT)
Hugh Dickins <hugh.dickins@tiscali.co.uk> wrote:

> On Sun, 6 Dec 2009, Greg KH wrote:
> 
> > 2.6.31-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > From: Soeren Sandmann <sandmann@daimi.au.dk>
> > 
> > commit d4515646699b6ad7b1a98ceb871296b957f3ef47 upstream.
> > 
> > Previously calling debug_kmap_atomic() with these types would
> > cause spurious warnings.
> > 
> > (triggered by SysProf using perf events)
> > 
> > Signed-off-by: Soeren Sandmann Pedersen <sandmann@redhat.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: a.p.zijlstra@chello.nl
> > LKML-Reference: <ye8vdhz8krw.fsf@camel23.daimi.au.dk>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> IIRC, this patch caused build failures in a number of architectures,
> those which didn't already define KM_NMI, KM_NMI_PTE or KM_IRQ_PTE
> e.g. compare the 2.6.32 arch/arm/include/asm/kmap_types.h against
> its 2.6.31 version.
> 
> Should be fixable if you include the extras necessary, but I'm
> ashamed to say I've left that as an exercise for the reader ;)
> 
> Hugh

grepping the git log for KM_NMI did find these two fixes in linus tree:

e8105903d78c81119754a42926951d9d17e191ba powerpc: Fix DEBUG_HIGHMEM build break from d4515646699
4ff1fa278b0bd1b2dd3c42efc0cb86788ffe05d5 [ARM] kmap: fix build errors with DEBUG_HIGHMEM enabled

hth,
Flo

