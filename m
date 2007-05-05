Return-Path: <linux-kernel-owner+w=401wt.eu-S933770AbXEEVXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770AbXEEVXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 17:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933674AbXEEVXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 17:23:18 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:47555 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933770AbXEEVXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 17:23:17 -0400
Date: Sun, 6 May 2007 00:23:15 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Frederik Deweerdt <deweerdt@free.fr>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] do_revoke error handling (was Re: 2.6.21-mm1)
In-Reply-To: <20070505211318.GA28912@slug>
Message-ID: <Pine.LNX.4.64.0705060017320.21257@sbz-30.cs.Helsinki.FI>
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
 <20070505211318.GA28912@slug>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2007 at 01:49:55AM -0700, Andrew Morton wrote:
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
> > 
> fs/revoke.c: In function 'do_revoke':
> fs/revoke.c:563: warning: 'details.fset' may be used uninitialized in this function
> fs/revoke.c:563: warning: 'details.restore_start' may be used uninitialized in this function

On Sat, 5 May 2007, Frederik Deweerdt wrote:
> It seems that we should goto 'out_free_table' if an error happens in
> the mainloop. Otherwise 'details' is passed to restore_files() without
> being initialized.

Good catch. The patch is wrong, though. Wwe must restore the file 
descriptors in case revoke fails; otherwise we'll leave non-revoked files 
hanging. The proper fix is to move initialization before the 
do_each_thread() bit. Care to make a new patch, Frederik?

				Pekka
