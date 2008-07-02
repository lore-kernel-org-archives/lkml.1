Return-Path: <linux-kernel-owner+w=401wt.eu-S1763072AbYGBHbK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763072AbYGBHbK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:31:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761036AbYGBHbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:31:00 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55787 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759850AbYGBHa7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:30:59 -0400
To: casey@schaufler-ca.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <486AC574.1080405@schaufler-ca.com> (message from Casey Schaufler
	on Tue, 01 Jul 2008 17:01:56 -0700)
Subject: Re: [patch] smack: remove unnecessary xattr checks
References: <E1KDmlY-0006ML-If@pomaz-ex.szeredi.hu> <486AC574.1080405@schaufler-ca.com>
Message-Id: <E1KDwno-0007QD-7d@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 02 Jul 2008 09:30:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Jul 2008, Casey Schaufler wrote:
> I tried your patch without looking at it and found that
> getxattr is too permissive with your changes. I found that
> 
>    % ls -l foo
> 
> will fail while
> 
>    % attr -S -g SMACK64 foo
> 
> will succeed. Of course if stat() fails due to a Smack
> access check getxattr() ought to as well. So it would
> appear that the call to security_inode_permission is not
> sufficient.

Hmm, I missed the fact that security_inode_permission() is only called
for xattrs not in the speclial (security.*, system.*, trusted.*)
namespaces.  So yes the patch is incorrect.

Thanks,
Miklos
