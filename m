Return-Path: <linux-kernel-owner+w=401wt.eu-S1760366AbYHUO50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760366AbYHUO50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757916AbYHUO4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:56:32 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:56023 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760207AbYHUO4a (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:56:30 -0400
Date: Thu, 21 Aug 2008 16:53:04 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Jared Hulbert <jaredeh@gmail.com>
cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-15?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 10/10] AXFS: axfs_uncompress.c
In-Reply-To: <6934efce0808210737w16b5f8dcr1657ea46099e4901@mail.gmail.com>
Message-ID: <alpine.LNX.1.10.0808211647500.12259@titan.stealer.net>
References: <48AD0126.1050609@gmail.com>  <alpine.LNX.1.10.0808211028150.12259@titan.stealer.net> <6934efce0808210737w16b5f8dcr1657ea46099e4901@mail.gmail.com>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 21 Aug 2008 14:53:19 +0000
	Bayes: 0.3121 Tokens: new, 170; hammy, 1; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3121]
X-Spam-Signature: ec28901491fb6eec6ae2d1e6112dad37c7269d22
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Aug 2008, Jared Hulbert wrote:

> > Use DEFINE_MUTEX and drop the mutex_init() down in the init function.
> 
> okay.  by drop you mean delete?

Yes.

> > axfs_uncompress_init() and axfs_uncompress_exit() are only called during
> > init and exit of the module, no need for the initialized variable and the
> > functions can be annotated with __init and __exit.
> 
> can be annotated or should be?

Should be. We only need them once during init and cleanup. If you want to 
call axfs_uncompress_exit() from init_axfs_fs() to clean up in case of 
register_filesystem failing, you can't annotate axfs_uncompress_exit() 
with __exit.

Sven
