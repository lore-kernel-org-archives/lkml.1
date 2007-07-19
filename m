Return-Path: <linux-kernel-owner+w=401wt.eu-S939154AbXGSPfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939154AbXGSPfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 11:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761853AbXGSPfo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 11:35:44 -0400
Received: from mail.fieldses.org ([66.93.2.214]:40738 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758498AbXGSPfn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 11:35:43 -0400
Date: Thu, 19 Jul 2007 11:35:36 -0400
To: Neil Brown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from
	show_expflags
Message-ID: <20070719153536.GB23093@fieldses.org>
References: <20070710121949.12548.patches@notabene> <1070710022737.13509@suse.de> <20070713002933.f15724a7.akpm@linux-foundation.org> <20070718230555.GN7111@fieldses.org> <18078.44366.961344.428533@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18078.44366.961344.428533@notabene.brown>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 19, 2007 at 10:16:14AM +1000, Neil Brown wrote:
> On Wednesday July 18, bfields@fieldses.org wrote:
> > On Fri, Jul 13, 2007 at 12:29:33AM -0700, Andrew Morton wrote:
> > > On Tue, 10 Jul 2007 12:27:37 +1000 NeilBrown <neilb@suse.de> wrote:
> > > 
> > > > +static void exp_flags(struct seq_file *m, int flag, int fsid,
> > > > +		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
> > > > +{
> > > > +	show_expflags(m, flag, NFSEXP_ALLFLAGS);
> > > >  	if (flag & NFSEXP_FSID)
> > > > -		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
> > > > +		seq_printf(m, ",fsid=%d", fsid);
> > > >  	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
> > > > -		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
> > > > +		seq_printf(m, ",sanonuid=%d", anonu);
> > > 
> > > It's a bit presumptuous to print a uid_t with "%d".  Fortunately it
> > > will work OK with all the present architectures.
> > > 
> > > But in general: be cautious when feeding opaque types to printk.
> > 
> > OK, here I'm still confused--what should we be doing instead?
> 
> Cast the variable to a type that printf knows about.
>        seq_printf(m, ",anonuid=%d", (int)anonu);
> 
> Or maybe cast it to (long) and use %ld, just in case...

OK.  In the event that uid_t some day ceases to eventually become an
int, will the casts help, or will they just suppress useful warnings?

> Note the stray 's' in the current patch, after the comma!

Sharp eyes, thanks!  I'll make a patch.  Uh, any objection if I print
all those uid's as unsigned while I'm at it?

--b.
