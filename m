Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896Ab0A2Wga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896Ab0A2Wga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:36:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755834Ab0A2Wg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:36:29 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33595 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab0A2Wg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:36:29 -0500
Date: Fri, 29 Jan 2010 17:36:27 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [patch 06/10] affs: Convert semaphores to mutexes
Message-ID: <20100129223627.GB18752@infradead.org>
References: <20100129203549.526478432@linutronix.de> <20100129203613.591137914@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100129203613.591137914@linutronix.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 29, 2010 at 08:38:55PM -0000, Thomas Gleixner wrote:
> These semaphores are plain mutexes. Convert them to struct mutex.

Looks good.

> Map affs_[un]lock_dir() to affs_[un]lock_ext() instead of the "#define
> i_hash_lock i_ext_lock" magic.

I'm not sure which of the remapping tricks is the worth one..

Btw, if we don't want lockdep to complain we'll need annotations on
affs_lock_dir as it's taken both on parent and child.

