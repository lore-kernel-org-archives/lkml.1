Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbYHKJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbYHKJcR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751079AbYHKJcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 05:32:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:55239 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025AbYHKJcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 05:32:04 -0400
From: Andreas Schwab <schwab@suse.de>
To: "Rakib Mullick" <rakib.mullick@gmail.com>
Cc: "Paul Menage" <menage@google.com>, "Paul Jackson" <pj@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup.c: remove goto statement from cgroup_init.
References: <b9df5fa10808110225r2772ab62w155fdec7af5759d8@mail.gmail.com>
X-Yow: I think my CAREER is RUINED!!
Date: Mon, 11 Aug 2008 11:32:02 +0200
In-Reply-To: <b9df5fa10808110225r2772ab62w155fdec7af5759d8@mail.gmail.com>
	(Rakib Mullick's message of "Mon, 11 Aug 2008 15:25:51 +0600")
Message-ID: <je8wv3dhil.fsf@sykes.suse.de>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rakib Mullick" <rakib.mullick@gmail.com> writes:

> Hello everyone, following patch removes the use of goto statement.
> Actually, we don't need it. Beacuse, if "err < 0", then it will never
> be TRUE.

What is "it"?

> --- linux-2.6.27-rc2.orig/kernel/cgroup.c	2008-08-11 15:16:49.000000000 +0600
> +++ linux-2.6.27-rc2/kernel/cgroup.c	2008-08-11 15:16:26.000000000 +0600
> @@ -2562,11 +2562,10 @@ int __init cgroup_init(void)
>
>  	err = register_filesystem(&cgroup_fs_type);
>  	if (err < 0)
> -		goto out;
> +		return err;
>
>  	proc_create("cgroups", 0, NULL, &proc_cgroupstats_operations);
>
> -out:
>  	if (err)
>  		bdi_destroy(&cgroup_backing_dev_info);

Doesn't this create a resource leak?

Andreas.

-- 
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
PGP key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
