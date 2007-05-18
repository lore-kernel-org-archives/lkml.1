Return-Path: <linux-kernel-owner+w=401wt.eu-S1759415AbXERLEV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759415AbXERLEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 07:04:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbXERLEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 07:04:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54282 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060AbXERLEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 07:04:10 -0400
Date: Fri, 18 May 2007 16:40:42 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jan Blunck <j.blunck@tu-harburg.de>
Subject: Re: [RFC][PATCH 10/14] In-kernel file copy between union mounted filesystems
Message-ID: <20070518111042.GC4869@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070514093722.GB4139@in.ibm.com> <20070514094329.GL4139@in.ibm.com> <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0705160951140.9570@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 09:57:28AM +0200, Jan Engelhardt wrote:
> 
> On May 14 2007 15:13, Bharata B Rao wrote:
> >+
> >+	if (flag & 0x2) {
> >+		error = union_copyup(nd, flag);
> >+		if (error)
> >+			goto exit;
> >+	}
> 
> What I dislike (and that also goes for fs/namei.c and such) that they use
> numeral constants, i.e. 0x2. That seems error-prone. Could this (and
> the in-kernel users of 0x1/0x2/0x4) be turned into some constant?
> 
> >+	if (IS_DEADDIR(parent->d_inode))
> >+		goto error;
> >+	err = -EACCES;	/* shouldn't it be ENOSYS? */
> 
> I do not think so. ENOSYS means Syscall not implemented. But it is
> implemented. If ->i_op is not there does not imply ENOSYS.
> 
> Though, now that I grep through fs/*, I see that namei.c also
> has that comment "shouldn't it be ENOSYS", so it's all at odds.
> 
> >+	if (!parent->d_inode->i_op || !parent->d_inode->i_op->create)
> >+		goto error;
> 
> >+struct dentry * union_create_topmost(struct nameidata *nd, struct dentry *old)
> >+{
> >+	struct dentry *dentry;
> >+	struct dentry *parent = nd->dentry;
> >+
> >+	UM_DEBUG_UID("dentry=%s\n", old->d_name.name);
> >+
> >+	BUG_ON(parent->d_sb == old->d_sb);
> >+	if (!S_ISREG(old->d_inode->i_mode)) {
> >+		UM_DEBUG("This filetype isn't supported!\n");
> 
> Does that mean I cannot create block devices, etc.?
> 

Not really. This is called during copyup of a file residing in a lower
layer. And that is done only for regular files.

Regards,
Bharata.
