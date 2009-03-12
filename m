Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZCLK15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZCLK15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 06:27:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbZCLK0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 06:26:15 -0400
Received: from mtagate8.de.ibm.com ([195.212.29.157]:49594 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756015AbZCLK0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:26:12 -0400
Date: Thu, 12 Mar 2009 11:25:36 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Greg KH <gregkh@suse.de>, Vegard Nossum <vegard.nossum@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       jbarnes@virtuousgeek.org, tj@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] sysfs: only allow one scheduled removal callback
 per kobj
Message-ID: <20090312112536.734ca15b@gondolin>
In-Reply-To: <20090311184225.GC23138@ldl.fc.hp.com>
References: <20090310232027.GC25665@ldl.fc.hp.com>
	<20090311044151.GB25840@suse.de>
	<20090311070359.GF25665@ldl.fc.hp.com>
	<20090311153228.GA21217@suse.de>
	<20090311184729.110761e4@gondolin>
	<20090311181904.GA10309@suse.de>
	<20090311184225.GC23138@ldl.fc.hp.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009 12:42:25 -0600,
Alex Chiang <achiang@hp.com> wrote:

> * Greg KH <gregkh@suse.de>:
> > On Wed, Mar 11, 2009 at 06:47:29PM +0100, Cornelia Huck wrote:
> > > (For the original oops, I'd rather solve the problem by making sure the
> > > caller doesn't trigger removal several times - should probably be less
> > > code than the proposed patch?)
> > 
> > Any ideas on how to do this?
> 
> I still think the original patch I proposed is the right answer.

How about just putting a marker on your device that is going to be
unregistered and refusing to schedule it again? (This marker could also
be used to block other undesired actions; that's what ccwgroup does.)
