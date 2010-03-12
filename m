Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0CLLiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 06:38:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:32447 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab0CLLiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 06:38:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=TUmsxeVyytGfviy/Cqd3DJhfaeq5joa/nDJUgZUo7oxPYzX8hsUUK1jcRNvv0UZanO
         0/Bkdy8OHMfrxuRPnxlB16ICDW2zkEkobDUny+0+6LkBo0GO/ThnZfU4Yr/fTCvbj4MP
         aNPvIe1x0PEKZvbIKxqSpPL9NHrfaL60B7Tzs=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: kay.sievers@vrfy.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
Subject: Re: [PATCH] devtmpfs: support !CONFIG_TMPFS
References: <1268389504-22179-1-git-send-email-jacmet@sunsite.dk>
	<4B9A2548.7050401@msgid.tls.msk.ru>
Date: Fri, 12 Mar 2010 12:38:08 +0100
In-Reply-To: <4B9A2548.7050401@msgid.tls.msk.ru> (Michael Tokarev's message of
	"Fri, 12 Mar 2010 14:28:08 +0300")
Message-ID: <87aaud22jj.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Michael" == Michael Tokarev <mjt@tls.msk.ru> writes:

Hi,

 >> +#ifdef CONFIG_TMPFS
 >> return get_sb_single(fs_type, flags, data, shmem_fill_super, mnt);
 >> +#else
 >> +	return get_sb_single(fs_type, flags, data, ramfs_fill_super, mnt);
 >> +#endif
 >> }

 Michael> May be completely not to the point or even wrong, but I were
 Michael> starring at this change for quite some time trying to understand
 Michael> what's the difference.  Can we do it like this:

 Michael> #ifdef CONFIG_TMPFS
 Michael> # define devtmpfs_fill_super shmem_fill_super
 Michael> #else
 Michael> # define devtmpfs_fill_super ramfs_fill_super
 Michael> #endif
 Michael>   	return get_sb_single(fs_type, flags, data, devtmpfs_fill_super, mnt);

 Michael> ?

Sure, if people find that cleaner - Kay?

-- 
Bye, Peter Korsgaard
