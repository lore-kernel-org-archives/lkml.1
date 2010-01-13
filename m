Return-Path: <linux-kernel-owner+w=401wt.eu-S1756136Ab0AMW5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0AMW5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 17:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755947Ab0AMW5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 17:57:18 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:50254 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0AMW5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 17:57:17 -0500
Date: Wed, 13 Jan 2010 22:57:16 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alexander Shishkin <virtuoso@slind.org>
Cc: Valdis.Kletnieks@vt.edu, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCHv3] List per-process file descriptor consumption
	when hitting file-max
Message-ID: <20100113225715.GE19799@ZenIV.linux.org.uk>
References: <28675.1248957636@turing-police.cc.vt.edu> <1263202687-18529-1-git-send-email-virtuoso@slind.org> <20100113224459.GA21934@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100113224459.GA21934@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:44:59PM +0000, Al Viro wrote:
> On Mon, Jan 11, 2010 at 11:38:07AM +0200, Alexander Shishkin wrote:
> > When a file descriptor limit is hit, display the top consumers of
> > descriptors so that it is possible to identify and fix those which
> > leak them.
> > 
> > Two new sysctl tunables are introduced:
> >   * file-max-consumers -- number of processes to display (defaults
> >     to 10);
> >   * file-max-rate-limit -- time interval between subsequent dumps
> >     (defaults to 10 seconds).
> 
> That *still* doesn't answer the most important question: what for?

BTW, even leaving that (and obvious deadlocks) aside, this stuff is
monumentally bogus.  A process can easily have shitloads of opened
descriptors and very few opened files (see dup() and friends).  Conversely,
you can have shitloads of opened files and not a single opened descriptor
(see mmap()).  And you are calling that when we have too many opened
struct file.
