Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbYFCLGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbYFCLGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 07:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYFCLF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 07:05:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:62690 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756572AbYFCLFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 07:05:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gPWSqnHpZR5KSeBZJ8YSFDhxV9MwWsVMqExrvotZRZo1x2U8CIk1KwmC56XBYvpVi6jzB3s8JmSCcXGEgax9VDV0XG5an7ZU8ShtKWleZ3EMeU1+84z7KLx9TStNBVeLiu5BHNY45543XPFo/n40y756GGdeckC+qCCQUPbgyBw=
Message-ID: <cfd18e0f0806030405u1c32b114pa0fdd979f36f87fb@mail.gmail.com>
Date: Tue, 3 Jun 2008 13:05:31 +0200
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] utimensat() non-conformances and fixes [v3]
Cc: drepper@redhat.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <48401E7E.9090304@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <482D4665.4050401@gmail.com>
	 <E1Jx3Gw-0002eA-55@pomaz-ex.szeredi.hu> <48401E7E.9090304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

> 2) I've found yet another divergence from the spec -- but this
> was in the original implementation, rather than being
> something that has been introduced.  In do_futimes() there is
>
>        if (!times && !(file->f_mode & FMODE_WRITE))
>                write_error = -EACCES;
>
> However, the check here should not be against the f_mode (file access
> mode), but the against actual permission of the file referred to by
> the underlying descriptor.  This means that for the do_futimes() +
> times==NULL case, a set-user-ID root program could open a file
> descriptor O_RDWR/O_WRONLY for which the real UID does not have write
> access, and then even after reverting the the effective UID, the real
> user could still update file.
>
> I'm not sure of the correct way to get the required nameidata (to do a
> vfs_permission() call) from the file descriptor.  Can you give me a
> tip there?

Could you point me at the right way of doing this?

Cheers,

Michael
