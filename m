Return-Path: <linux-kernel-owner+w=401wt.eu-S1760216AbYHUO4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760216AbYHUO4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:56:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757623AbYHUO4K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:56:10 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:56008 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484AbYHUO4H (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:56:07 -0400
Date: Thu, 21 Aug 2008 16:54:44 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 06/10] AXFS: axfs_super.c
In-Reply-To: <alpine.LNX.1.10.0808211325530.12259@titan.stealer.net>
Message-ID: <alpine.LNX.1.10.0808211653501.12259@titan.stealer.net>
References: <48AD0101.4020505@gmail.com> <alpine.LNX.1.10.0808211325530.12259@titan.stealer.net>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.6
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 21 Aug 2008 14:55:05 +0000
	Bayes: 0.1282 Tokens: new, 181; hammy, 2; neutral, 2; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.1282]
X-Spam-Signature: ba79ef31b79739ccb7b9f8bf9737265fb8b46bf9
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Sven Wegener wrote:

> On Wed, 20 Aug 2008, Jared Hulbert wrote:
> 
> > The many different devices AXFS can mount to and the various
> > dual device mounting schemes are supported here.
> > 
> > Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
> > ---
> > +static int __init init_axfs_fs(void)
> > +{
> > +	axfs_uncompress_init();
> 
> one more thing, axfs_uncompress_init() can fail
> 
> > +	return register_filesystem(&axfs_fs_type);

And if this fails you leak the memory allocated in axfs_uncompress_init()

> > +}
> > +
> > +static void __exit exit_axfs_fs(void)
> > +{
> > +	axfs_uncompress_exit();
> > +	unregister_filesystem(&axfs_fs_type);
> > +}
> > +
> > +module_init(init_axfs_fs);
> > +module_exit(exit_axfs_fs);
> > +MODULE_LICENSE("GPL");
