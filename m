Return-Path: <linux-kernel-owner+w=401wt.eu-S934521AbYD1NuD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934521AbYD1NuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:50:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932153AbYD1Ntx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:49:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:54284 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932140AbYD1Ntx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:49:53 -0400
Date: Mon, 28 Apr 2008 06:49:25 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] x86: mtrr cleanup for converting continuous to discrete
 layout v2
Message-ID: <20080428064925.318659b9@laptopd505.fenrus.org>
In-Reply-To: <20080428130826.GH27997@elte.hu>
References: <200804272337.40130.yhlu.kernel@gmail.com>
	<200804280206.52641.yhlu.kernel@gmail.com>
	<20080428130826.GH27997@elte.hu>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 15:08:26 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Yinghai Lu <yhlu.kernel.send@gmail.com> wrote:
> 
> > some BIOS like to use continus MTRR layout, and X driver can not
> > add WB entries for graphical cards when 4g or more RAM installed.
> > 
> > the patch will change MTRR to discrete.
> > 
> > mtrr_chunk_size= could be used to have smaller continuous block to 
> > hold holes. default is 256m, could be set according to size of 
> > graphics card memory.
> 
> hm.
> 
> > +static int disable_mtrr_cleanup;
> 
> i think this should be default-disabled. Touching MTRRs on a live
> system could interact with SMM and MCE handlers.

yep one should not touch existing MTRRs. If you run out, tough luck.
Thats what we have PAT for.
Changing them anyway is a deathtrap with various things, suspend/resume being only
one of the nasty cases.

> 
> how relevant is this feature with modern Xorg? I thought modern Xorg 
> would get its mappings via /sys, hence it would not have to touch
> MTRRs at all.

that's true for current X, but not for 6 month old X :=(

-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
