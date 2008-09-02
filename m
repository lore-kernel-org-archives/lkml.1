Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYIBFEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYIBFEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 01:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbYIBFE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 01:04:27 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:55790 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbYIBFEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 01:04:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=FDyeFOH/cFdU5IeNaItE1eNDgnBMDGD1ce0aW64CI1MsdGHKHUUO+a+Md7Hs0Hg2HM
         XqCzQAj9a9pO3ewviNc0C2codWg8zAS1gxWy8lUITlEY8S+9gVM2wyIPqJFjjR1/I3fj
         ZrGGks+5ex9aNlpjaZBp+06hXNYyG0ncaQeaU=
Date: Tue, 2 Sep 2008 09:06:01 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Kentaro Takeda <takedakn@nttdata.co.jp>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: (repost) Confirmation of methods for calculating requested
	pathname.
Message-ID: <20080902050601.GA4149@x200.localdomain>
References: <48AA49DE.6000006@nttdata.co.jp> <48BCC1B6.5030901@nttdata.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48BCC1B6.5030901@nttdata.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2008 at 01:31:50PM +0900, Kentaro Takeda wrote:
> Al, could you answer the following question?
> 
> 
> The current Linux kernel is not designed to pass vfsmount parameter
> that is crucial for pathname-based security including AppArmor and
> TOMOYO Linux, to LSM. Though both projects have been proposing
> patches to calculate pathname, none of them have been accepted as
> you know.
> 
> To find the reason for NACK, we examined past proposals and the
> threads. And we came to understand that you oppose accessing vfsmount
> inside vfs helper functions. Is our understanding correct?
> 
> If our understanding is correct, we would like to propose a new
> method that does not require modifications to vfs helper functions.
> Attached patch is a trial of this method.
> 
> vfs helper functions are surrounded by mnt_want_write() and
> mnt_drop_write() pairs which receive "struct vfsmount" parameter
> since 2.6.26. So, by remembering the absolute pathname of "struct
> vfsmount" of the moment, LSM module can calculate an absolute
> pathname of the given "struct dentry" parameter inside vfs_*
> functions, without passing "struct vfsmount" parameter to vfs_*
> functions.
> 
> This approach doesn't access vfsmount inside vfs helper functions,
> and modification of existing kernel is only in task_struct and
> mnt_want/drop_write().

I don't know what Al Viro will say, but this is incredibly ugly.
Even more ugly than previous patches.

