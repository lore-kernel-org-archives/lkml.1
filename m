Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbYBNQNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbYBNQNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 11:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYBNQNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 11:13:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:36655 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYBNQNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 11:13:17 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=q/YX359/CV0Ebhms06Rs4JThphix+611xxlvjwjfQ090rzF17bZYOGQ0y2oFVdz0L
	r42UrqG2UfBtH+SkB5o3w==
Message-ID: <6599ad830802140813n71b56dccud33e19642a0d7647@mail.gmail.com>
Date: Thu, 14 Feb 2008 08:13:09 -0800
From: "Paul Menage" <menage@google.com>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 14, 2008 at 8:03 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>  > The "flags" argument could be the same as for regular mount, and
>  > contain the mnt_flags - so the extra argument could maybe usefully be
>  > a "mnt_flags_mask", to indicate which flags we actually care about
>  > overriding.
>
>  The way I imagined it, is that mnt_flags is a mask, and the operation
>  (determined by flags) is either:
>
>   - set bits in mask
>   - clear bits in mask (or not in mask)
>   - set flags to mask
>
>  It doesn't allow setting some bits, clearing some others, and leaving
>  alone the rest.  But I think such flexibility isn't really needed.

I think I'd suggest something like:

new_mnt->mnt_flags = (old_mnt->mnt_flags & ~arg_mask) | (arg_flags & mask)

>  Maybe instead of messing with masks, it's better to introduce a
>  get_flags() or a more general mount_stat() operation, and let
>  userspace deal with setting and clearing flags, just as we do for
>  stat/chmod?
>
>  So we'd have
>
>   mount_stat(path, stat);
>   mount_bind(from, to, flags);
>   mount_set_flags(path, flags);
>   mount_move(from, to);
>
>  and perhaps
>
>   mount_remount(path, opt_string, flags);

Sounds reasonable to me. But it wouldn't directly solve the "do a
recursive bind mount setting the MS_READONLY flag on all children"
problem, so we'd need some of the earlier suggestions too.

Paul
