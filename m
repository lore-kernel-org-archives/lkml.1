Return-Path: <linux-kernel-owner+w=401wt.eu-S1758306AbYFLJjH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758306AbYFLJjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 05:39:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYFLJiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 05:38:54 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:8284 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbYFLJix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=j/TxhC10T8B7t83d238XRivbqiAqIEaxjnnFMb89ZoYpJxiimALfktmY1rkiEi93wJ
         G9IhaSyGXslOs404aE8Jn65FF4SuEiTRc1fdxHOQ7z+PmFmv8OVLaNj+8BBxED9B4Gsn
         ZOe2l1/NJ/MLHP4bapSVWLMlK2OXDdGMtsUNU=
Message-ID: <e9e943910806120238k73736218k8aa34857497b348a@mail.gmail.com>
Date: Thu, 12 Jun 2008 10:38:53 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Andreas Dilger" <adilger@sun.com>
Subject: Re: [PATCH 4/6] ext2: tighten restrictions on inode flags
Cc: akpm@linux-foundation.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080612090629.GX3726@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1213142649-32685-1-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-2-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-3-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-4-git-send-email-duaneg@dghda.com>
	 <1213142649-32685-5-git-send-email-duaneg@dghda.com>
	 <20080612090629.GX3726@webber.adilger.int>
X-Google-Sender-Auth: 6405cdebfc375355
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/6/12 Andreas Dilger <adilger@sun.com>:
> On Jun 11, 2008  01:04 +0100, Duane Griffin wrote:
>> At the moment there are few restrictions on which flags may be set on which
>> inodes. Specifically DIRSYNC may only be set on directories and IMMUTABLE
>> and APPEND may not be set on links. Tighten that to disallow TOPDIR being
>> set on non-directories and SECRM, UNRM, COMPR, SYNC, DIRTY, COMPRBLK,
>> NOCOMP, ECOMPR, INDEX, JOURNAL_DATA and NOTAIL being set on anything but
>> regular files or directories.
>>
>> Introduce a flags masking function which masks flags based on mode and use
>> it during inode creation and when flags are set via the ioctl to facilitate
>> future consistency.
>
> This second set of patches is missing out on the presence of the
> "EXT2_FL_USER_MODIFIABLE" mask in ext2_ioctl(EXT2_IOC_SETFLAGS).  This is
> what prevents "unsettable" flags from being set from userspace.
>
> I don't have any objection to additional filtering to avoid setting the
> USER_MODIFIABLE flags on special files.

OK, thanks. I convinced myself that the patch wouldn't actually change
behaviour in the ioctl case, but thought it best to use it anyway for
consistency and to avoid future problems. I should probably have
mentioned that in the ChangeLog; I never know quite how exhaustive to
be in these things...

> Cheers, Andreas

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
