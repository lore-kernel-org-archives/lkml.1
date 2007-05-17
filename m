Return-Path: <linux-kernel-owner+w=401wt.eu-S1756772AbXEQMGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772AbXEQMGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 08:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755646AbXEQMGM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 08:06:12 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41063 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbXEQMGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 08:06:12 -0400
Date: Thu, 17 May 2007 05:04:23 -0700
From: Greg KH <greg@kroah.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH -stable] sysfs: disable reclamation by default
Message-ID: <20070517120423.GE17712@kroah.com>
References: <464A4F56.6080108@tequila.co.jp> <20070515185350.2e77bf21.akpm@linux-foundation.org> <464AE56F.3040101@gmail.com> <20070516082935.fe112ab5.akpm@linux-foundation.org> <464B2605.9040200@gmail.com> <20070516091346.3c76cb46.akpm@linux-foundation.org> <464B4DE4.9060100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464B4DE4.9060100@gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2007 at 08:31:00PM +0200, Tejun Heo wrote:
> sd->s_dentry updates made by dentry/inode reclamation are racy and can
> lead to BUG() or oops.  This is already fixed in -mm and the fix is
> scheduled to be merged into upstream for 2.6.23 but the fix
> reimplements sysfs dentry dropping and is too risky for -stable
> kernels.
> 
> This is an interim solution for -stable kernels.  sysfs reclamation is
> disabled by default and can be enabled by using sysfs.enable_reclaim
> kernel parameter.  Note that dentries are still created on demand, so
> attribute and symlinks nodes aren't allocated on creation.  They're
> allocated on first lookup and deallocated when the sysfs node is
> removed.

Ick, this is going to kill memory on big boxes (s390 and others) and I
don't really want to apply this it if at all possible.

Maneesh, any other thoughts?

thanks,

greg k-h
