Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbYALX4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbYALX4Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 18:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYALX4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 18:56:06 -0500
Received: from phunq.net ([64.81.85.152]:34659 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751645AbYALX4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 18:56:05 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFD] Incremental fsck
Date: Sat, 12 Jan 2008 15:55:53 -0800
User-Agent: KMail/1.9.5
Cc: Alan <alan@clueserver.org>, Al Boldi <a1426z@gawab.com>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200801090022.55589.a1426z@gawab.com> <60808.198.182.194.170.1199827911.squirrel@clueserver.org> <20080109091656.GL3351@webber.adilger.int>
In-Reply-To: <20080109091656.GL3351@webber.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801121555.54533.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 January 2008 01:16, Andreas Dilger wrote:
> While an _incremental_ fsck isn't so easy for existing filesystem
> types, what is pretty easy to automate is making a read-only snapshot
> of a filesystem via LVM/DM and then running e2fsck against that.  The
> kernel and filesystem have hooks to flush the changes from cache and
> make the on-disk state consistent.
>
> You can then set the the ext[234] superblock mount count and last
> check time via tune2fs if all is well, or schedule an outage if there
> are inconsistencies found.
>
> There is a copy of this script at:
> http://osdir.com/ml/linux.lvm.devel/2003-04/msg00001.html
>
> Note that it might need some tweaks to run with DM/LVM2
> commands/output, but is mostly what is needed.

You can do this now with ddsnap (an out-of-tree device mapper target) 
either by checking a local snapshot or a replicated snapshot on a 
different machine, see:

    http://zumastor.org/

Doing the check on a remote machine seems attractive because the fsck 
does not create a load on the server.

Regards,

Daniel
