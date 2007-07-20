Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbXGTCVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbXGTCVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754658AbXGTCV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:21:27 -0400
Received: from ns2.suse.de ([195.135.220.15]:39242 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758974AbXGTCVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:21:25 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Fri, 20 Jul 2007 12:21:16 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18080.7196.844577.295882@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from
	show_expflags
In-Reply-To: message from J. Bruce Fields on Thursday July 19
References: <20070710121949.12548.patches@notabene>
	<1070710022737.13509@suse.de>
	<20070713002933.f15724a7.akpm@linux-foundation.org>
	<20070718230555.GN7111@fieldses.org>
	<18078.44366.961344.428533@notabene.brown>
	<20070719153536.GB23093@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday July 19, bfields@fieldses.org wrote:
> On Thu, Jul 19, 2007 at 10:16:14AM +1000, Neil Brown wrote:
> > On Wednesday July 18, bfields@fieldses.org wrote:
> > > OK, here I'm still confused--what should we be doing instead?
> > 
> > Cast the variable to a type that printf knows about.
> >        seq_printf(m, ",anonuid=%d", (int)anonu);
> > 
> > Or maybe cast it to (long) and use %ld, just in case...
> 
> OK.  In the event that uid_t some day ceases to eventually become an
> int, will the casts help, or will they just suppress useful warnings?

Probably not.  Just leave it as it is.

> 
> > Note the stray 's' in the current patch, after the comma!
> 
> Sharp eyes, thanks!  I'll make a patch.  Uh, any objection if I print
> all those uid's as unsigned while I'm at it?

I wondered about that too.  I think we have completely removed the
fiction that 'nobody' is '-2' rather than '65534' so it should be both
safe and sensible to make them unsigned.

NeilBrown
