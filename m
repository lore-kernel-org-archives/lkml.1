Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbYFXAOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbYFXAOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 20:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYFXANx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 20:13:53 -0400
Received: from smtp-1.hut.fi ([130.233.228.91]:49067 "EHLO smtp-1.hut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbYFXANw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 20:13:52 -0400
X-Greylist: delayed 5900 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 20:13:52 EDT
Date: Tue, 24 Jun 2008 01:32:39 +0300
From: Sami Liedes <sliedes@cc.hut.fi>
To: Duane Griffin <duaneg@dghda.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Message-ID: <20080623223238.GA8802@vipunen.hut.fi>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org> <1214258200-16623-1-git-send-email-duaneg@dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214258200-16623-1-git-send-email-duaneg@dghda.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-TKK-Virus-Scanned: by amavisd-new-2.1.2-hutcc at katosiko.hut.fi
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 10:56:40PM +0100, Duane Griffin wrote:
> If the orphan node list includes valid, untruncatable nodes with nlink > 0
> the ext3_orphan_cleanup loop which attempts to delete them will not do so,
> causing it to loop forever. Fix by checking for such nodes in the
> ext3_orphan_get function.

You people working hard to fix bugs and implement great filesystems
almost makes me feel bad for trying to break your code :)

> diff --git a/fs/ext3/ialloc.c b/fs/ext3/ialloc.c
> index 7712682..bc030f4 100644
> --- a/fs/ext3/ialloc.c
> +++ b/fs/ext3/ialloc.c
[...]
> @@ -690,6 +698,7 @@ bad_orphan:
>  		printk(KERN_NOTICE "NEXT_ORPHAN(inode)=%u\n",
>  		       NEXT_ORPHAN(inode));
>  		printk(KERN_NOTICE "max_ino=%lu\n", max_ino);
> +		printk(KERN_NOTICE "i_nlink=%lu\n", inode->i_nlink);
					    ^^^

Here I get (on x86 gcc 4.3.1):

fs/ext3/ialloc.c: In function 'ext3_orphan_get':
fs/ext3/ialloc.c:701: warning: format '%lu' expects type 'long unsigned int', but argument 2 has type 'unsigned int'

So it probably should be %u or something.

	Sami
