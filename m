Return-Path: <linux-kernel-owner+w=401wt.eu-S2992477AbXDLKey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992477AbXDLKey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992475AbXDLKey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:34:54 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:34281 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992469AbXDLKew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:34:52 -0400
Date: Thu, 12 Apr 2007 11:37:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       John Johansen <jjohansen@suse.de>, Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 37/41] AppArmor: Main Part
Message-ID: <20070412113723.2ec7e4f0@the-village.bc.nu>
In-Reply-To: <20070412090848.752885000@suse.de>
References: <20070412090809.917795000@suse.de>
	<20070412090848.752885000@suse.de>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> + * aa_taskattr_access
> + * @name: name of the file to check
> + *
> + * Check if name matches /proc/self/attr/current, with self resolved
> + * to the current pid. This file is the usermode iterface for
> + * changing one's hat.
> + */
> +static inline int aa_taskattr_access(const char *name)
> +{
> +	unsigned long pid;
> +	char *end;
> +
> +	if (strncmp(name, "/proc/", 6) != 0)
> +		return 0;

The proc file system may not be mounted at /proc. There are environments
where this is done for good reason (eg not wanting the /proc info exposed
to a low trust environment). Another is when FUSE is providing an
arbitrated proc either by merging across clusters or by removing stuff.

> +static int aa_file_denied(struct aa_profile *profile, const char *name,
> +			  int mask)
> +{
> +	int perms;
> +
> +	/* Always allow write access to /proc/self/attr/current. */
> +	if (mask == MAY_WRITE && aa_taskattr_access(name))
> +		return 0;

Why can't this be done in the profile itself to avoid kernel special case
uglies and inflexibility ?

> +		if (PTR_ERR(sa->name) == -ENOENT && (check & AA_CHECK_FD))
> +			denied_mask = 0;

Now there is an interesting question. Is PTR_ERR() safe for kernel
pointers on all platforms or just for user ones ?


