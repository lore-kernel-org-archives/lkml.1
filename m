Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYAGBNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYAGBNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 20:13:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbYAGBNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 20:13:36 -0500
Received: from lixom.net ([66.141.50.11]:59567 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbYAGBNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 20:13:35 -0500
Date: Sun, 6 Jan 2008 19:22:37 -0600
From: Olof Johansson <olof@lixom.net>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       heiko.carstens@de.ibm.com, mingo@elte.hu, mpm@selenic.com
Subject: Re: [PATCH] Add bug/warn marker to generic report_bug()
Message-ID: <20080107012237.GA16790@lixom.net>
References: <20080105190713.73745ec6@laptopd505.fenrus.org> <20080106202223.GA12640@lixom.net> <20080106133817.4f42ab82@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080106133817.4f42ab82@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06, 2008 at 01:38:17PM -0800, Arjan van de Ven wrote:
> On Sun, 6 Jan 2008 14:22:23 -0600
> Olof Johansson <olof@lixom.net> wrote:
> 
> > Powerpc uses the generic report_bug() from lib/bug.c to report
> > warnings, and I'm guessing other arches do as well.
> > 
> > Add the module list as well as the end-of-trace marker to the output.
> > This required making print_oops_end_marker() nonstatic.
> > 
> > 
> 
> this is the wrong approach...
> powerpc and such should just use oops_enter() / oops_exit() to signal the start/end of such 
> a trace, that gives them all the other behavior of oopsing as well (such as the "slow oops scrolling down" etc)

Note that this is for warnings, not oopses.

This comment in oops_enter threw me off of using it:

        debug_locks_off(); /* can't trust the integrity of the kernel
	anymore */

Since we can very well depend on the integrity of the kernel when it's
just doing a __WARN().

do_warn_slowpath() doesn't use oops_enter() either.


-Olof
