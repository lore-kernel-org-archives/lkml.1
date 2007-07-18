Return-Path: <linux-kernel-owner+w=401wt.eu-S1760019AbXGROst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760019AbXGROst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816AbXGROsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:48:42 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:14681 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759AbXGROsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nFUFJb4rJ+6PvQZYAkkDBtlX1/FsFs7lzIV8jOoa7aD/cawwws2hvYhiH4/9N9R/8z/HsDQu/pAmpJFVUmRMRxFz1ewGH7yIqgL7IFJLGvwCKEujFYXBwCP2rTQhnwciFxt8uqEHWc3gxwFp0LET4hAn31E10CxBZ5qVEeULPdw=
Message-ID: <a781481a0707180748j4760ab8bo237c1abc02feb593@mail.gmail.com>
Date: Wed, 18 Jul 2007 20:18:40 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: [PATCH] sysfs: kill an extra put in sysfs_create_link() failure path
Cc: "Gabriel C" <nix.or.die@googlemail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
In-Reply-To: <20070718071445.GI23568@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a781481a0707142239l397672c6p4fd1dc8dfb73e07c@mail.gmail.com>
	 <a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	 <469A9D5D.10509@googlemail.com> <469B61C8.8010902@googlemail.com>
	 <a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	 <469BB7B8.3060002@gmail.com> <469BB9CA.6090500@googlemail.com>
	 <469BC2D6.5090008@googlemail.com> <469BC34C.4080107@googlemail.com>
	 <20070718071445.GI23568@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

Thanks for tracking this down and fixing it.

On 7/18/07, Tejun Heo <htejun@gmail.com> wrote:
> There is a subtle bug in sysfs_create_link() failure path.  When
> symlink creation fails because there's already a node with the same
> name, the target sysfs_dirent is put twice - once by failure path of
> sysfs_create_link() and once more when the symlink is released.

The "symlink" is released? But the creation of the symlink is
precisely what failed here ... did it not?

> Fix it by making only the symlink node responsible for putting
> target_sd.

And again ... the changelog sounds confusing indeed, perhaps I'm
not familiar enough with sysfs symlink-related terminology/semantics.
Care to elaborate?

>         sd = sysfs_new_dirent(name, S_IFLNK|S_IRWXUGO, SYSFS_KOBJ_LINK);
>         if (!sd)
>                 goto out_put;
> +
>         sd->s_elem.symlink.target_sd = target_sd;
> +       target_sd = NULL;       /* reference is now owned by the symlink */

Wow. This looks like a very mysterious way to fix a mysterious bug :-)
BTW I just looked over at sysfs_create_link() and ... it looks quite ...
unnecessarily complicated/obfuscated ...

Thanks again,
Satyam
