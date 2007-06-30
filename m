Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbXF3JPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbXF3JPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 05:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbXF3JOz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 05:14:55 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:60616 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbXF3JOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 05:14:54 -0400
Date: Sat, 30 Jun 2007 10:14:52 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: jjohansen@suse.de, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [RFD 1/4] Pass no useless nameidata to the create, lookup, and permission IOPs
Message-ID: <20070630091452.GB21784@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Erez Zadok <ezk@cs.sunysb.edu>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, Andreas Gruenbacher <agruen@suse.de>
References: <20070626231541.697783295@suse.de> <200706270011.l5R0BfPO011424@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706270011.l5R0BfPO011424@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 08:11:41PM -0400, Erez Zadok wrote:
> Perhaps it is also time to put the dentry + mnt into a single struct path?
> It's a small change, but it emphasizes that the two items here, dentry+mnt,
> really define a single path to be passed around:

No.  The vfsmount will go away completely medium-term once we get right
of the atomic open nfs hack that paases a file back in the open intent.
A normal filesystem has not business looking at the vfsmount instance at
all, and the raw open/create we need to replace the atomic open hack
will need the full nameidata per definition, also to allow things like
a multi-component lookup that various cluster/network filesystems really
want.

