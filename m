Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbXI3Jx3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbXI3Jx3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 05:53:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbXI3JxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 05:53:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:52034 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbXI3JxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 05:53:18 -0400
Date: Sun, 30 Sep 2007 10:53:10 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: casey@schaufler-ca.com, torvalds@linux-foundation.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>,
       Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory Access Control Kernel
Message-ID: <20070930095310.GA18642@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
	torvalds@linux-foundation.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@suse.de>, James Morris <jmorris@namei.org>,
	Paul Moore <paul.moore@hp.com>
References: <46FEEBD4.5050401@schaufler-ca.com> <20070930011618.ccb8351b.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070930011618.ccb8351b.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2007 at 01:16:18AM -0700, Andrew Morton wrote:
> reviewed the August thread from your version 1 submission and the message I
> take away is that the code has been well-received and looks good when
> considered on its own merits, but selinux could probably be configured to
> do something sufficiently similar.
> 
> I'd have trouble declaring that "but" to be a reason to not merge smack.
> I'm more thinking "let's merge it and see if people use it".

I'm not sure this was discussed on the list, but as long as Casey doesn't
get rid of the magic symlinks (smackfs_follow_link), there's a clear NACK
from the VFS perspective.

Otherwise the code looks pretty well written, alhough a run through
checkpath.pl to fix the lose end might help.  Oh, and please to compile-time
initializations for the spinlocks and mutex currently initializes in
smack_init.  Also the -Inet/netlabel looks rather odd, please work with
the netlabel maintainer to move the required files to the include/
hierachy.
