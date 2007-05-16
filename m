Return-Path: <linux-kernel-owner+w=401wt.eu-S1763078AbXEPUG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763078AbXEPUG7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 16:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbXEPUGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 16:06:51 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:43041 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753152AbXEPUGu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 16:06:50 -0400
Date: Wed, 16 May 2007 15:06:47 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Bharata B Rao <bharata@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH  8/14] Union-mount lookup
Message-ID: <20070516200647.GA8961@sergelap.austin.ibm.com>
References: <20070514093722.GB4139@in.ibm.com> <20070514094218.GJ4139@in.ibm.com> <Pine.LNX.4.61.0705150937590.9570@yvahk01.tjqt.qr> <20070516050851.GB4403@in.ibm.com> <Pine.LNX.4.61.0705162127080.9019@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705162127080.9019@yvahk01.tjqt.qr>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jan Engelhardt (jengelh@linux01.gwdg.de):
> 
> On May 16 2007 10:38, Bharata B Rao wrote:
> >> 
> >> >+lookup_union:
> >> >+	do {
> >> >+		struct vfsmount *mnt = find_mnt(topmost);
> >> >+		UM_DEBUG_DCACHE("name=\"%s\", inode=%p, device=%s\n",
> >> >+				topmost->d_name.name, topmost->d_inode,
> >> >+				mnt->mnt_devname);
> >> >+		mntput(mnt);
> >> >+	} while (0);
> >> 
> >> Why the extra do{}while? [elsewhere too]
> >
> >Not sure, may be to get a scope to define 'mnt' here. Jan ?
> 
> What I was implicitly suggesting that mnt could be moved into the
> normal 'function scope'.
> 
> 
> 	Jan

This code can't stay anyway so it's kind of moot.  find_mnt() is bogus,
and the topmost and overlaid mappings need to be changed from
dentry->dentry to (vfsmnt,dentry)->(vfsmnt,dentry) in order to cope with
bind mounts and mount namespaces.

-serge
