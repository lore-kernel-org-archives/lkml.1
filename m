Return-Path: <linux-kernel-owner+w=401wt.eu-S933439AbYEIFfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933439AbYEIFfL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 01:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbYEIFev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 01:34:51 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:8546 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbYEIFes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 01:34:48 -0400
Date: Fri, 9 May 2008 07:32:40 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>, Greg KH <greg@kroah.com>,
       benh@kernel.crashing.org, Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, tony@bakeyournoodle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Silence 'ignoring return value' warnings in
 drivers/video/aty/radeon_base.c
Message-ID: <20080509073240.49f09ac2@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1210291364.19279.62.camel@brick>
References: <20080506143936.6357e578.akpm@linux-foundation.org>
	<20080506.144301.233784820.davem@davemloft.net>
	<1210121683.21644.194.camel@pasglop>
	<20080506182006.4b4a3968.akpm@linux-foundation.org>
	<1210134804.21644.202.camel@pasglop>
	<20080507102310.57b4ccfb@gondolin.boeblingen.de.ibm.com>
	<1210196621.1421.5.camel@pasglop>
	<20080508093421.31cd735b@gondolin.boeblingen.de.ibm.com>
	<1210232984.1421.47.camel@pasglop>
	<20080508103621.69bc47cf@gondolin.boeblingen.de.ibm.com>
	<20080508220348.GD7705@kroah.com>
	<18467.37312.772564.163109@cargo.ozlabs.ibm.com>
	<1210291364.19279.62.camel@brick>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 17:02:44 -0700,
Harvey Harrison <harvey.harrison@gmail.com> wrote:

> On Fri, 2008-05-09 at 09:50 +1000, Paul Mackerras wrote:
> > I think the best solution is to make a new sysfs_maybe_create_file()
> > which isn't marked must_check, and then move suitable callers (such as
> > radeonfb) over to that.  That will make it obvious in the callers that
> > the file creation isn't guaranteed.

Either that...

> 
> Or just a a flag parameter to the existing one that says whether failure
> is allowed or not.  In a case that fails, a WARN_ON can be printed from
> the common create_file rather than putting printks all over the kernel.

...or that. But the core should still warn about duplicate files in all
cases, since that indicates a bug. (And that will catch the problems we
found before; IIRC a core warning didn't exist back then.)

> 
> This would also document which files are necessary vs. optional.

Shouldn't that rather go into Documentation/ABI/, so that people can
easily find out what they may rely on?
