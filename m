Return-Path: <linux-kernel-owner+w=401wt.eu-S1756370AbYLPL5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370AbYLPL5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 06:57:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753748AbYLPL5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 06:57:07 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:3565 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbYLPL5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 06:57:07 -0500
X-BigFish: VPS-35(z34a4jz1432R62a3L98dR936eQ1805Mzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KBYX6R-02-B99-01
Date: Tue, 16 Dec 2008 12:56:09 +0100
From: Robert Richter <robert.richter@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 08/10] oprofile: set values to default when creating
	oprofilefs
Message-ID: <20081216115609.GA15411@erda.amd.com>
References: <1229007886-14362-1-git-send-email-robert.richter@amd.com> <1229007886-14362-9-git-send-email-robert.richter@amd.com> <20081216013225.272a5fd1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081216013225.272a5fd1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 16 Dec 2008 11:56:52.0709 (UTC) FILETIME=[629DC950:01C95F75]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.12.08 01:32:25, Andrew Morton wrote:
> > +unsigned long fs_buffer_size;
> > +unsigned long fs_cpu_buffer_size;
> > +unsigned long fs_buffer_watershed;
> 
> These were poorly chosen kernel-wide identifiers.

Right, didn't notice that. Will change this.

> >  static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
> >  {
> > @@ -120,6 +124,11 @@ static const struct file_operations dump_fops = {
> >  
> >  void oprofile_create_files(struct super_block *sb, struct dentry *root)
> >  {
> > +	/* reinitialize default values */
> > +	fs_buffer_size =	FS_BUFFER_SIZE_DEFAULT;
> > +	fs_cpu_buffer_size =	FS_CPU_BUFFER_SIZE_DEFAULT;
> > +	fs_buffer_watershed =	FS_BUFFER_WATERSHED_DEFAULT;
> > +
> >  	oprofilefs_create_file(sb, root, "enable", &enable_fops);
> >  	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
> >  	oprofilefs_create_file(sb, root, "buffer", &event_buffer_fops);
> 
> afacit oprofile_create_files() only gets run when the module is loaded,
> so this patch is a no-op?

This code runs when oprofilefs is mounted. This happens typically in
an opcontrol --init/--deinit sequence. Before, the previous values
would have been used after mounting again. Now, default values are
restored.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

