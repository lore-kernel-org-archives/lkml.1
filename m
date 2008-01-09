Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbYAIMmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbYAIMmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbYAIMmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:42:43 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:38925 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYAIMml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:42:41 -0500
To: kzak@redhat.com
CC: akpm@linux-foundation.org, hch@infradead.org, serue@us.ibm.com,
       viro@ftp.linux.org.uk, ebiederm@xmission.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, util-linux-ng@vger.kernel.org
In-reply-to: <20080109111120.GI3926@petra.dvoda.cz> (message from Karel Zak on
	Wed, 9 Jan 2008 12:11:20 +0100)
Subject: Re: [patch 6/9] unprivileged mounts: allow unprivileged mounts
References: <20080108113502.184459371@szeredi.hu> <20080108113629.192719163@szeredi.hu> <20080109111120.GI3926@petra.dvoda.cz>
Message-Id: <E1JCaFY-0005iK-LM@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 09 Jan 2008 13:41:40 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Jan 08, 2008 at 12:35:08PM +0100, Miklos Szeredi wrote:
> > Define a new fs flag FS_SAFE, which denotes, that unprivileged mounting of
> > this filesystem may not constitute a security problem.
> > 
> > Since most filesystems haven't been designed with unprivileged mounting in
> > mind, a thorough audit is needed before setting this flag.
> > 
> > For "safe" filesystems also allow unprivileged forced unmounting.
> 
>  What about to list "safe" filesystems anywhere in /proc/fs/ ? I think
>  it's very important information for admins.

Makes sense.  I'll cook up something.

>  Note, your patch for mount(8) is always trying to use unprivileged
>  mount(2) for non-root users. It's overkill when unprivileged mounts are
>  supported for bind mounts and fuse only. It would be nice to check
>  if FS is "safe" before switch to unprivileged mode.

I think the little gain in performance is not worth the added
complexity.  Especially if the added complexity is in the privileged
part, and itself can be a source of security holes.

>  The "safe" definition is also very subjective and it depends on your
>  level of paranoia. There should be a way (e.g. /proc) how control and
>  modify the list of "safe" filesystems. For example I have no problem
>  to mark cifs as "safe" for my home server.

OK, also makes some sense.  Pavel's examples do point out that fuse
isn't as safe as I'd like it to be, so perhaps it would make sense to
default to just bind mounts being allowed, and having to explicity
enable unprivileged fuse mounts with a sysctl or whatever.

Miklos
