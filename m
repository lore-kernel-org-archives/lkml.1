Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbZFTJMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbZFTJMs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 05:12:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbZFTJMh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 05:12:37 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:54815 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbZFTJMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 05:12:36 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A3CA7FB.60707@s5r6.in-berlin.de>
Date: Sat, 20 Jun 2009 11:12:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090523 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Sage Weil <sage@newdream.net>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       greg@kroah.com
Subject: Re: [PATCH 17/21] ceph: nfs re-export support
References: <1245450702-31343-1-git-send-email-sage@newdream.net> <1245450702-31343-2-git-send-email-sage@newdream.net> <1245450702-31343-3-git-send-email-sage@newdream.net> <1245450702-31343-4-git-send-email-sage@newdream.net> <1245450702-31343-5-git-send-email-sage@newdream.net> <1245450702-31343-6-git-send-email-sage@newdream.net> <1245450702-31343-7-git-send-email-sage@newdream.net> <1245450702-31343-8-git-send-email-sage@newdream.net> <1245450702-31343-9-git-send-email-sage@newdream.net> <1245450702-31343-10-git-send-email-sage@newdream.net> <1245450702-31343-11-git-send-email-sage@newdream.net> <1245450702-31343-12-git-send-email-sage@newdream.net> <1245450702-31343-13-git-send-email-sage@newdream.net> <1245450702-31343-14-git-send-email-sage@newdream.net> <1245450702-31343-15-git-send-email-sage@newdream.net> <1245450702-31343-16-git-send-email-sage@newdream.net> <1245450702-31343-17-git-send-email-sage@newdream.net> <1245450702-31343-18-git-send-email-sage@newdream.n!
 et>
In-Reply-To: <1245450702-31343-18-git-send-email-sage@newdream.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sage Weil wrote:
> +++ b/fs/staging/ceph/export.c
...
> +static struct dentry *ceph_fh_to_parent(struct super_block *sb, struct fid *fid,
> +				 int fh_len, int fh_type)
> +{
> +	u32 *fh = fid->raw;
> +	u64 ino = *(u64 *)fh;
> +	u32 hash = fh[2];
> +
> +	derr(10, "fh_to_parent %llx.%x\n", ino, hash);
> +
> +	if (fh_len < 6)
> +		return ERR_PTR(-ESTALE);
> +
> +	return __fh_to_dentry(sb, (struct ceph_export_item *)fh + 1,
> +			      fh_len/IPSZ - 1);
> +}

fid->raw could be 32-bit aligned, couldn't it?

#include <asm/unaligned.h>

	u64 ino = get_unaligned((u64 *)fh);

	derr(10, "fh_to_parent %llx.%x\n",
	     (unsigned long long)ino, hash);

(not tested)

I remember somebody saying that u64 should become unsigned long long on 
all architectures eventually; is there still such a plan?
-- 
Stefan Richter
-=====-==--= -==- =-=--
http://arcgraph.de/sr/
