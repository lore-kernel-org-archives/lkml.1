Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbYCUSLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbYCUSLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 14:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756316AbYCUSLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 14:11:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37879 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbYCUSLJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 14:11:09 -0400
Date: Fri, 21 Mar 2008 18:11:05 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: haveblue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, neilb@suse.de, akpm@linux-foundation.org,
       hch@infradead.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org
Subject: Re: r-o bind in nfsd
Message-ID: <20080321181105.GW10722@ZenIV.linux.org.uk>
References: <E1Jciie-0001E6-Dx@pomaz-ex.szeredi.hu> <20080321155451.GU10722@ZenIV.linux.org.uk> <E1Jck2N-0001Q3-7W@pomaz-ex.szeredi.hu> <20080321163520.GV10722@ZenIV.linux.org.uk> <E1JckW9-0001Ub-Rs@pomaz-ex.szeredi.hu> <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jckjd-0001X8-IM@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 21, 2008 at 06:08:53PM +0100, Miklos Szeredi wrote:

> > And having the vfsmount available within vfs_...() functions means,
> > that the mnt_want_write() check can be moved inside, which means that
> > callers get simpler and less likely to be buggy.  Those are all
> > advantages IMO, regardless of any security module issues.
> 
> Or we can introduce another set of exported functions (path_mkdir(),
> ...), and leave vfs_...() alone.  And then the only question is if
> LSM's can live with ordering change.

I really don't see the point of new helpers; especially since one doesn't
have to _have_ vfsmount to use the old ones and since we don't have a lot
of users of each of those to start with.

As for the apparmor and friends...  I'm far past the point of trying to
give them feedback, seeing how any such feedback is ignored, if not worse
(the ugliness of some of the suggested kludges is bloody astonishing - e.g.
some guy proposed to stuff a reference to vfsmount into task_struct, etc.)
