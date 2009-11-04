Return-Path: <linux-kernel-owner+w=401wt.eu-S1754682AbZKDE1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682AbZKDE1Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 23:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754663AbZKDE1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 23:27:15 -0500
Received: from 139-142-54-143.atc.vaillant.ca ([139.142.54.143]:35922 "EHLO
	quartz.edm.orcorp.ca" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754626AbZKDE1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 23:27:15 -0500
Date: Tue, 3 Nov 2009 21:27:17 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Valdis.Kletnieks@vt.edu
Cc: Hal Finney <hal.finney@gmail.com>, tpmdd-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com
Subject: Re: [tpmdd-devel] [PATCH] TPM: Let the tpm char device be openable multiple times
Message-ID: <20091104042717.GS1966@obsidianresearch.com>
References: <20091103003511.GL7768@obsidianresearch.com> <da7b3ce30911030931u1ccbff69ted4206606475c83@mail.gmail.com> <6926.1257272068@turing-police.cc.vt.edu> <20091103224157.GA20963@obsidianresearch.com> <13189.1257305069@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13189.1257305069@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 10:24:29PM -0500, Valdis.Kletnieks@vt.edu wrote:

> A number of other things under drivers/ implement "only one open" semantics,
> but those are hard-coded into the driver. But for the TPM, it's unclear if
> exclusive or non-exclusive is the right model. 

The underlying hardware already supports multiplexing multiple clients
in the same command stream - I'm not sure why this shouldn't be
exported to user space as-is. The kernel already accesses the TPM
without going through the middleware for in kernel features..

> Maybe the right answer is to default to multiple opens, but have an
> ioctl() that turns on exclusive mode.  If you have a 'tcsd' daemon,
> it will need to get launched early enough to do the open/ioctl

Why is this an issue? /dev/tpm is root only accessible. There are a lot
of things that can go horribly wrong if root does improper things, and
you can create quite reasonable multi-process tpm using applications
without the middleware.

Even if another root process does open /dev/tpm - what is the worst it
can do?

Jason
