Return-Path: <linux-kernel-owner+w=401wt.eu-S1754398AbYAQAdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbYAQAdm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752587AbYAQAdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:33:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50622 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbYAQAd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:33:29 -0500
From: Neil Brown <neilb@suse.de>
To: Jan Engelhardt <jengelh@computergmbh.de>
Date: Thu, 17 Jan 2008 11:33:09 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18318.41541.386224.301640@notabene.brown>
Cc: Karel Zak <kzak@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, util-linux-ng@vger.kernel.org,
       linuxram@us.ibm.com, viro@ftp.linux.org.uk, hch@infradead.org,
       a.p.zijlstra@chello.nl
Subject: Re: [patch] VFS: extend /proc/mounts
In-Reply-To: message from Jan Engelhardt on Thursday January 17
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu>
	<20080116143051.ec488f3d.akpm@linux-foundation.org>
	<20080116234339.GG26049@petra.dvoda.cz>
	<Pine.LNX.4.64.0801170057520.31385@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday January 17, jengelh@computergmbh.de wrote:
> 
> On Jan 17 2008 00:43, Karel Zak wrote:
> >> 
> >> Seems like a plain bad idea to me.  There will be any number of home-made
> >> /proc/mounts parsers and we don't know what they do.
> >
> > So, let's use /proc/mounts_v2  ;-)
> 
> Was not it like "don't use /proc for new things"?

I thought it was "don't use /proc for new things that aren't process
related".

And as the mount table is per process......

A host has a bunch of mounted filesystems (struct super_block), and
each process has some subset of these stitched together into a mount
tree (struct vfsmount / struct namespace).

There needs to be something in /proc that exposes the vfsmount tree.

Arguably there should be something else - maybe in sysfs - that
provides access to the "struct superblock" object.

And there needs to be a clear way to relate information from one with
information from the other.

In the tradition of stat, statm, status, maybe the former should be
 /proc/$PID/mountm
:-)

Hey, I just found /proc/X/mountstats.  How does this fit in to the big
picture?

NeilBrown
