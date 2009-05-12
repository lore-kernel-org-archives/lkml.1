Return-Path: <linux-kernel-owner+w=401wt.eu-S1753476AbZELOTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476AbZELOTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 10:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751949AbZELOTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 10:19:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:45371 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbZELOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 10:19:45 -0400
From: Arnd Bergmann <ARNDB@de.ibm.com>
Organization: IBM Deutschland Research & Development GmbH, Vorsitzender des Aufsichtsrats: Johann Weihen, Geschaeftssfuehrung: Erich Baier, Sitz der Gesellschaft: Boeblingen, Registergericht: Amtsgericht Stuttgart, HRB 243294
To: jblunck@suse.de
Subject: Re: [patch 2/2] spufs: remove double check for non-negative dentry
Date: Tue, 12 May 2009 16:15:25 +0200
User-Agent: KMail/1.9.9
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Jeremy Kerr <jk@ozlabs.org>
References: <20090505213203.797397821@suse.de> <20090505214434.097370118@suse.de>
In-Reply-To: <20090505214434.097370118@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905121615.25936.ARNDB@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 May 2009, jblunck@suse.de wrote:
> This patch removes an unnecessary double check if the dentry returned by
> lookup_create() is actually non-negative. Since lookup_create() itself returns
> an error in this case just remove the check.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>

Looks good, I'll push this one on, unless Jeremy has objections.

Thanks,

	Arnd <><

> --- a/arch/powerpc/platforms/cell/spufs/inode.c
> +++ b/arch/powerpc/platforms/cell/spufs/inode.c
> @@ -625,10 +625,6 @@ long spufs_create(struct nameidata *nd,
>  	if (IS_ERR(dentry))
>  		goto out_dir;
>  
> -	ret = -EEXIST;
> -	if (dentry->d_inode)
> -		goto out_dput;
> -
>  	mode &= ~current->fs->umask;
>  
>  	if (flags & SPU_CREATE_GANG)
> 
