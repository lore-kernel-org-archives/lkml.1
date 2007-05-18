Return-Path: <linux-kernel-owner+w=401wt.eu-S1758840AbXERNWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758840AbXERNWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 09:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755090AbXERNWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 09:22:12 -0400
Received: from ns.suse.de ([195.135.220.2]:57812 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXERNWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 09:22:11 -0400
From: Andi Kleen <ak@suse.de>
To: Anton Blanchard <anton@samba.org>
Subject: Re: select(0, ..) is valid ?
Date: Fri, 18 May 2007 15:21:33 +0200
User-Agent: KMail/1.9.1
Cc: Hugh Dickins <hugh@veritas.com>, Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Badari Pulavarty <pbadari@us.ibm.com>, netdev@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, sfr@canb.auug.org.au
References: <1179250159.2836.117.camel@dyn9047017100.beaverton.ibm.com> <Pine.LNX.4.64.0705151927360.28895@blonde.wat.veritas.com> <20070516153703.GA26912@kryten>
In-Reply-To: <20070516153703.GA26912@kryten>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705181521.34339.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 May 2007 17:37, Anton Blanchard wrote:
> Hi Hugh,
>
> > It's interesting that compat_core_sys_select() shows this kmalloc(0)
> > failure but core_sys_select() does not.  That's because core_sys_select()
> > avoids kmalloc by using a buffer on the stack for small allocations (and
> > 0 sure is small).  Shouldn't compat_core_sys_select() do just the same?
> > Or is SLUB going to be so efficient that doing so is a waste of time?
>
> Nice catch, the original optimisation from Andi is:
>
> http://git.kernel.org/git-new/?p=linux/kernel/git/torvalds/linux-2.6.git;a=
>commit;h=70674f95c0a2ea694d5c39f4e514f538a09be36f
>
> And I think it makes sense for the compat code to do it too.

Yes agreed. I just forgot the copy'n'pasted code when doing the original
change.

-Andi
