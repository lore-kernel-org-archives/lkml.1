Return-Path: <linux-kernel-owner+w=401wt.eu-S1754163AbYAWMzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163AbYAWMzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 07:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYAWMzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 07:55:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:44119 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176AbYAWMzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:55:08 -0500
Date: Wed, 23 Jan 2008 12:55:04 +0000
From: Christoph Hellwig <hch@infradead.org>
To: David Chinner <dgc@sgi.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org
Subject: Re: do_remount_sb(RDONLY) race? (was: XFS oops under 2.6.23.9)
Message-ID: <20080123125504.GC25395@infradead.org>
References: <200801230430.m0N4UmpU029430@turbo.physics.adelaide.edu.au> <20080123053412.GN155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123053412.GN155259@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 04:34:12PM +1100, David Chinner wrote:
> I've had suspicions of a race in the remount-ro code in
> do_remount_sb() w.r.t to the fs_may_remount_ro() check.  That is, we
> do an unlocked check to see if we can remount readonly and then fail
> to check again once we've locked the superblock out and start the
> remount.

This code is inherently racy, and will be replaced with a proper
per-vfsmount writer count in 2.6.25 as part of the per-mount r/o patches.

