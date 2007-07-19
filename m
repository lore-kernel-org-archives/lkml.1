Return-Path: <linux-kernel-owner+w=401wt.eu-S1764633AbXGSAQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764633AbXGSAQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbXGSAQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:16:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:33095 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754243AbXGSAQ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:16:27 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Thu, 19 Jul 2007 10:16:14 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18078.44366.961344.428533@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from
	show_expflags
In-Reply-To: message from J. Bruce Fields on Wednesday July 18
References: <20070710121949.12548.patches@notabene>
	<1070710022737.13509@suse.de>
	<20070713002933.f15724a7.akpm@linux-foundation.org>
	<20070718230555.GN7111@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday July 18, bfields@fieldses.org wrote:
> On Fri, Jul 13, 2007 at 12:29:33AM -0700, Andrew Morton wrote:
> > On Tue, 10 Jul 2007 12:27:37 +1000 NeilBrown <neilb@suse.de> wrote:
> > 
> > > +static void exp_flags(struct seq_file *m, int flag, int fsid,
> > > +		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
> > > +{
> > > +	show_expflags(m, flag, NFSEXP_ALLFLAGS);
> > >  	if (flag & NFSEXP_FSID)
> > > -		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
> > > +		seq_printf(m, ",fsid=%d", fsid);
> > >  	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
> > > -		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
> > > +		seq_printf(m, ",sanonuid=%d", anonu);
> > 
> > It's a bit presumptuous to print a uid_t with "%d".  Fortunately it
> > will work OK with all the present architectures.
> > 
> > But in general: be cautious when feeding opaque types to printk.
> 
> OK, here I'm still confused--what should we be doing instead?

Cast the variable to a type that printf knows about.
       seq_printf(m, ",anonuid=%d", (int)anonu);

Or maybe cast it to (long) and use %ld, just in case...

Note the stray 's' in the current patch, after the comma!

NeilBrown
