Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYAFHyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYAFHyb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 02:54:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbYAFHyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 02:54:22 -0500
Received: from 1wt.eu ([62.212.114.60]:1182 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751567AbYAFHyV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 02:54:21 -0500
Date: Sun, 6 Jan 2008 08:45:58 +0100
From: Willy Tarreau <w@1wt.eu>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
Message-ID: <20080106074558.GA388@1wt.eu>
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp> <20071231200247.GA30373@sergelap.austin.ibm.com> <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp> <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp> <20080106062609.GC20753@1wt.eu> <200801061636.GFE34382.FLtOMSOFHVOFJQ@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801061636.GFE34382.FLtOMSOFHVOFJQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 04:36:06PM +0900, Tetsuo Handa wrote:
> Hello.
> 
> Willy Tarreau wrote:
> > Your patch is very confusing. In your description, as well as in the
> > comments you talk about tmpfs, but your patch does not touch even one
> > line of tmpfs and only changes ramfs. Even your variables and arguments
> > refer to tmpfs. The Kconfig entry indicates that the feature depends
> > on TMPFS too.
> > 
> > Judging from the following comment :
> >   * Original tmpfs doesn't set ramfs_dir_inode_operations.setattr field.
> > 
> > I suspect that you confuse both filesystems.
> >   - ramfs is in fs/ramfs and is always compiled in, you cannot disable it
> >   - tmpfs is in mm/shmem.c and is optional. It also supports options that
> >     ramfs does not (eg: size) and data may be swapped.
> > 
> > Please understand that I'm not discussing the usefulness of your patch,
> > I'm just trying to avoid a huge confusion.
> 
> Oh, I thought the filesystem mounted by "mount -t tmpfs none /tmp" is "tmpfs"

Yes, that is a tmpfs.

> and the source code of "tmpfs" is located in fs/ramfs directory.

No, ramfs is what you get by "mount -t ramfs none /tmp" :-)
You will notice that "df" will not report your ramfs by default because it
reports zero blocks. But "mount" or "df /tmp" will report it.

> So, I should write the description as "an extension to ramfs" rather than
> "an extension to tmpfs".

and please also the comments, macros and variable names in the code, as they
are what confused me first.

> I'll fix it in next posting.

Thanks,
Willy

