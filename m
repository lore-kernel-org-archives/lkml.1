Return-Path: <linux-kernel-owner+w=401wt.eu-S1763194AbXJZWGc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763194AbXJZWGc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 18:06:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751551AbXJZWGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 18:06:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:58938 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbXJZWGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 18:06:22 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs
To: Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: [AppArmor 32/45] Enable LSM hooks to distinguish operations on file descriptors from operations on pathnames
Date: Fri, 26 Oct 2007 23:56:06 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
References: <20071026064024.243943043@suse.de> <200710262224.45773.agruen@suse.de> <1193432291.4721.27.camel@localhost>
In-Reply-To: <1193432291.4721.27.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710262356.06562.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2007 22:58:11 Miklos Szeredi wrote:
> For special files, f_op->fsetattr will be NULL, since
> init_special_inode() will set up i_fop that way.
>
> So the filesystem's fsetattr() will only be called for regular files
> and/or directories, depending on how it sets up i_fop.
>
> With the ia_file thing, the filesystem would receive the struct file
> pointer in all cases.  So the posted patch would break AFS and FUSE,
> because they unconditionally use ia_file if available and don't check
> the file type.

Ah okay, that's what you mean. That's much cleaner than ia_file indeed.

> They could check the file type, but still the interface would be ugly.

Agreed, that would be ugly.

> Ah, so if we kept ATTR_FILE and got rid of iattr_file, would that be OK
> for AppArmor?

No problem, yes.

Thanks,
Andreas
