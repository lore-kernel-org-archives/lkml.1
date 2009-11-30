Return-Path: <linux-kernel-owner+w=401wt.eu-S1753307AbZK3CLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbZK3CLj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 21:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZK3CLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 21:11:38 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49648 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066AbZK3CLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 21:11:37 -0500
Date: Sun, 29 Nov 2009 21:11:11 -0500
Message-Id: <200911300211.nAU2BBrT007283@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/41] VFS: Make real_lookup() return a struct path 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:03 PDT."
             <1256152779-10054-6-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-6-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> This patch changes real_lookup() into returning a struct path.
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c |   82 +++++++++++++++++++++++++++++++++++++----------------------
>  1 files changed, 51 insertions(+), 31 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 9c9ecfa..a338496 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -462,10 +462,11 @@ ok:
>   * make sure that nobody added the entry to the dcache in the meantime..
>   * SMP-safe
>   */
> -static struct dentry * real_lookup(struct dentry * parent, struct qstr * name, struct nameidata *nd)
> +static int real_lookup(struct nameidata *nd, struct qstr *name,
> +		       struct path *path)
>  {

Same comments I had on patch 3:

- document in comment and patch header the new @path parameter, who is
  responsible for it, new return err, etc.

- consider adding BUG_ON(!path)

- perhaps VFS this should also be pushed upstream before UM

Erez.
