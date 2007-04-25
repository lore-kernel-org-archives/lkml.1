Return-Path: <linux-kernel-owner+w=401wt.eu-S2992866AbXDYRUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992866AbXDYRUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 13:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992878AbXDYRUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 13:20:19 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57892 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992864AbXDYRUQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 13:20:16 -0400
Date: Wed, 25 Apr 2007 12:20:12 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       serue@us.ibm.com, viro@ftp.linux.org.uk, linuxram@us.ibm.com,
       ebiederm@xmission.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org,
       linux-security-module@vger.kernel.org
Subject: Re: [patch] unprivileged mounts update
Message-ID: <20070425172012.GA20336@sergelap.austin.ibm.com>
References: <E1HgcBv-00049Z-00@dorka.pomaz.szeredi.hu> <E1HgjG0-0005CN-00@dorka.pomaz.szeredi.hu> <462F87EA.1000002@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <462F87EA.1000002@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting H. Peter Anvin (hpa@zytor.com):
> Miklos Szeredi wrote:
> > 
> > Andrew, please skip this patch, for now.
> > 
> > Serge found a problem with the fsuid approach: setfsuid(nonzero) will
> > remove filesystem related capabilities.  So even if root is trying to
> > set the "user=UID" flag on a mount, access to the target (and in case
> > of bind, the source) is checked with user privileges.
> > 
> > Root should be able to set this flag on any mountpoint, _regardless_
> > of permissions.
> > 
> 
> Right, if you're using fsuid != 0, you're not running as root 

Sure, but what I'm not clear on is why, if I've done a
prctl(PR_SET_KEEPCAPS, 1) before the setfsuid, I still lose the
CAP_FS_MASK perms.  I see the special case handling in
cap_task_post_setuid().  I'm sure there was a reason for it, but
this is a piece of the capability implementation I don't understand
right now.

I would send in a patch to make it honor current->keep_capabilities,
but I have a feeling there was a good reason not to do so in the
first place.

> (fsuid is
> the equivalent to euid for the filesystem.)

If it were really the equivalent then I could keep my capabilities :)
after changing it.

> I fail to see how ruid should have *any* impact on mount(2).  That seems
> to be a design flaw.

May be, but just using fsuid at this point stops me from enabling user
mounts under /share if /share is chmod 000 (which it is).

thanks,
-serge
