Return-Path: <linux-kernel-owner+w=401wt.eu-S1762768AbXJEMyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762768AbXJEMyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 08:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756037AbXJEMyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 08:54:44 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:60137 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119AbXJEMyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 08:54:43 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Takenori Nagano <t-nagano@ah.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function
References: <4704D0BA.4090507@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 06:49:40 -0600
In-Reply-To: <4704D0BA.4090507@ah.jp.nec.com> (Takenori Nagano's message of
	"Thu, 04 Oct 2007 20:38:34 +0900")
Message-ID: <m1ir5llo9n.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Takenori Nagano <t-nagano@ah.jp.nec.com> writes:

> This patch adds new notifier function tunable_notifier_chain. Its base is
> atomic_notifier_chain.



> +/**
> + * tunable_notifier_chain_register - Add notifier to an tunable notifier chain
> + *	@nh: Pointer to head of the tunable notifier chain
> + *	@n: New entry in notifier chain
> + *	@name: Pointer to the name of this notifier chain
> + *	@desc: Pointer to the description of new entry
> + *
> + *	Adds a notifier to an tunable notifier chain and makes control dir.
> + *
> + *	Returns zero on success or %-ENODEV on failure.
> + */
> +
> +int tunable_notifier_chain_register(struct tunable_notifier_head *nh,
> +		struct tunable_notifier_block *n, char *name, char *desc)
> +{
> +	unsigned long flags;
> +	int ret = -EINVAL;
> +	struct dentry *nh_dir, *nb_dir, *pri_dentry, *desc_dentry = NULL;
> +
> +	if (!name)
> +		goto nb_fail;
> +
> +	ret = -ENOMEM;
> +	if (!nh->dir) {
> +		nh_dir = debugfs_create_dir(nh->name, NULL);

Hmm. debugfs does not appear to be an appropriate place to create
files that are supposed to be part of a serious user space interface.

Eric
