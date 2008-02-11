Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbYBKU0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbYBKU0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 15:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754281AbYBKU0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 15:26:03 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:41944 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754091AbYBKU0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 15:26:01 -0500
Date: Mon, 11 Feb 2008 15:20:07 -0500
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
To: Nur Hussein <nurhussein@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, gregkh@suse.de
Subject: Re: [PATCH 1/1] Taint kernel after WARN_ON(condition)
Message-ID: <20080211202007.GC25262@josefsipek.net>
References: <20080211195222.GA5809@gandalf.middleearth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080211195222.GA5809@gandalf.middleearth>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 03:52:22AM +0800, Nur Hussein wrote:
> This patch will taint the kernel with a new flag, 'W', whenever a
> warning is issued with WARN_ON(condition). Whenever a warning occurs, it
> is helpful to record this within the kernel state as a taint. When a BUG
> happens, it'd be useful to know if it was also preceded by a WARN.

Any architecture that has it's own WARN_ON will not taint the kernel.

Speaking of WARN_ON...

$ git-grep "[^A-Za-z_0-9]WARN_ON(1)" | wc -l
180

Maybe making a WARN() (similar to BUG) that does an unconditional warning
(and sets the taint flag) and having a simple wrapper around it for the
conditional WARN_ON would be worth it? Hm...looks like some of the USB folks
have a #define'd WARN to something quite a bit more complex (format string,
etc.)

Josef 'Jeff' Sipek.

-- 
Linux, n.:
  Generous programmers from around the world all join forces to help
  you shoot yourself in the foot for free. 
