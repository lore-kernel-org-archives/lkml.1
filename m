Return-Path: <linux-kernel-owner+w=401wt.eu-S1753808AbYIBOG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808AbYIBOG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 10:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751647AbYIBOGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 10:06:18 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:54956 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409AbYIBOGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 10:06:17 -0400
To: sds@tycho.nsa.gov
CC: serge@hallyn.com, takedakn@nttdata.co.jp, viro@ZenIV.linux.org.uk,
       linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp
In-reply-to: <1220362640.26711.69.camel@moss-spartans.epoch.ncsc.mil> (message
	from Stephen Smalley on Tue, 02 Sep 2008 09:37:20 -0400)
Subject: Re: (repost) Confirmation of methods for calculating requested
	pathname.
References: <48AA49DE.6000006@nttdata.co.jp>
	 <48BCC1B6.5030901@nttdata.co.jp>  <20080902131127.GA5951@hallyn.com> <1220362640.26711.69.camel@moss-spartans.epoch.ncsc.mil>
Message-Id: <E1KaWW9-0005j6-TZ@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 02 Sep 2008 16:06:01 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 02 Sep 2008, Stephen Smalley wrote:
> No, that idea seemingly died because both Al and Miklos thought it was
> wrong to add new security hooks to the same code path (vs. moving the
> existing ones to the callers),

I do think that duplicating hooks is the wrong approach, but it does
have the minimal impact of all the solutions, and the duplication can
be consolidated later.  So in the end this might be the easiest way
forward.

What Al is violently opposed to is removing the vfs_foo() API which
separates the "VFS core", which doesn't know anything abount mounts,
from the rest of the VFS.

But as Jamie pointed out, we've already sneaked in vfsmounts via the
r/o bind mounts patches.  I don't see why we would need to strictly
separate the mount namespace handling from the VFS core.

Miklos
