Return-Path: <linux-kernel-owner+w=401wt.eu-S934166AbXGRXGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166AbXGRXGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755889AbXGRXGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:06:04 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47009 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473AbXGRXGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:06:03 -0400
Date: Wed, 18 Jul 2007 19:05:55 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [NFS] [PATCH 013 of 20] knfsd: nfsd: factor out code from
	show_expflags
Message-ID: <20070718230555.GN7111@fieldses.org>
References: <20070710121949.12548.patches@notabene> <1070710022737.13509@suse.de> <20070713002933.f15724a7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070713002933.f15724a7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2007 at 12:29:33AM -0700, Andrew Morton wrote:
> On Tue, 10 Jul 2007 12:27:37 +1000 NeilBrown <neilb@suse.de> wrote:
> 
> > +static void exp_flags(struct seq_file *m, int flag, int fsid,
> > +		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
> > +{
> > +	show_expflags(m, flag, NFSEXP_ALLFLAGS);
> >  	if (flag & NFSEXP_FSID)
> > -		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
> > +		seq_printf(m, ",fsid=%d", fsid);
> >  	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
> > -		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
> > +		seq_printf(m, ",sanonuid=%d", anonu);
> 
> It's a bit presumptuous to print a uid_t with "%d".  Fortunately it
> will work OK with all the present architectures.
> 
> But in general: be cautious when feeding opaque types to printk.

OK, here I'm still confused--what should we be doing instead?

--b.
