Return-Path: <linux-kernel-owner+w=401wt.eu-S1761561AbYCXOy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761561AbYCXOy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 10:54:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761328AbYCXOyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 10:54:45 -0400
Received: from lazybastard.de ([212.112.238.170]:32831 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761288AbYCXOyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 10:54:44 -0400
Date: Mon, 24 Mar 2008 15:54:33 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: Andrew Morton <akpm@osdl.org>, Paul Mundt <lethal@linux-sh.org>,
       linux-sh <linux-sh@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>
Subject: Re: [PATCH] 2/3 mtd: add support for flash on the SEGA Dreamcast Visual Memory Unit
Message-ID: <20080324145433.GD2899@logfs.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206209035.6324.29.camel@localhost.localdomain> <20080322183200.GD19347@logfs.org> <1206211147.6324.48.camel@localhost.localdomain> <20080324020832.GA13935@linux-sh.org> <1206360384.6283.11.camel@localhost.localdomain> <20080324132101.GA2899@logfs.org> <1206367120.6283.15.camel@localhost.localdomain> <20080324141043.GB2899@logfs.org> <1206369796.6283.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1206369796.6283.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 March 2008 14:43:16 +0000, Adrian McMenamin wrote:
> 
> Well, I haven't got round to applying them and testing them yet, though
> they look ok, obviously, except for one thing: I'm pretty much where you
> are on the goto versus return thing, but got pretty clear instructions
> on a previous patch from Andrew Morton that using gotos to ensure
> functions limit the number of return points is the way to go.
> 
> I've added him back in now we aren't exchanging flames, so maybe he can
> pronouce ex cathedra.

It is a matter of personal taste.  Having a single return statement is
nice when using a debugger.  One can set a single breakpoint instead of
ten.  I guess that is why Andrew prefers it.

I personally don't care much either way and usually pick whatever needs
fewer lines.  Main purpose of the patch was to merge the error path with
the good path.  In several functions you have

	free_this;
	free_that;
	return 0;

error1:
	free_this;
error2:
	free_that;
error3:
	return error;

Those paths are nearly identical and should be combined.  As always,
duplicated code has a tendency to diverge, so in most cases the two
copies have subtle differences.  So far I just tackled the easy cases.

Jörn

-- 
Joern's library part 8:
http://citeseer.ist.psu.edu/plank97tutorial.html
