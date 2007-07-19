Return-Path: <linux-kernel-owner+w=401wt.eu-S935022AbXGSAUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935022AbXGSAUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 20:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761652AbXGSAUF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 20:20:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54663 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761954AbXGSAUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 20:20:03 -0400
Date: Wed, 18 Jul 2007 17:18:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from
 show_expflags
Message-Id: <20070718171859.8d1276fd.akpm@linux-foundation.org>
In-Reply-To: <20070718230555.GN7111@fieldses.org>
References: <20070710121949.12548.patches@notabene>
	<1070710022737.13509@suse.de>
	<20070713002933.f15724a7.akpm@linux-foundation.org>
	<20070718230555.GN7111@fieldses.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 19:05:55 -0400
"J. Bruce Fields" <bfields@fieldses.org> wrote:

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
> 

Nothing? I was just having a little self-muse.

If one was really anal, one could typecast it to an unsigned long long in
the printk, then feel smug when we switch to 64-bit uid's.

