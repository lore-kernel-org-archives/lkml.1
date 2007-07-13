Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbXGMH37@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbXGMH37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:29:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbXGMH3x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:29:53 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:42411 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752752AbXGMH3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:29:52 -0400
Date: Fri, 13 Jul 2007 00:29:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: NeilBrown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "J. Bruce Fields" <bfields@citi.umich.edu>
Subject: Re: [PATCH 013 of 20] knfsd: nfsd: factor out code from
 show_expflags
Message-Id: <20070713002933.f15724a7.akpm@linux-foundation.org>
In-Reply-To: <1070710022737.13509@suse.de>
References: <20070710121949.12548.patches@notabene>
	<1070710022737.13509@suse.de>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2007 12:27:37 +1000 NeilBrown <neilb@suse.de> wrote:

> +static void exp_flags(struct seq_file *m, int flag, int fsid,
> +		uid_t anonu, uid_t anong, struct nfsd4_fs_locations *fsloc)
> +{
> +	show_expflags(m, flag, NFSEXP_ALLFLAGS);
>  	if (flag & NFSEXP_FSID)
> -		seq_printf(m, "%sfsid=%d", first++?",":"", fsid);
> +		seq_printf(m, ",fsid=%d", fsid);
>  	if (anonu != (uid_t)-2 && anonu != (0x10000-2))
> -		seq_printf(m, "%sanonuid=%d", first++?",":"", anonu);
> +		seq_printf(m, ",sanonuid=%d", anonu);

It's a bit presumptuous to print a uid_t with "%d".  Fortunately it
will work OK with all the present architectures.

But in general: be cautious when feeding opaque types to printk.
