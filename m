Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbXKWCx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbXKWCx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 21:53:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbXKWCxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 21:53:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:52795 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXKWCxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 21:53:19 -0500
Date: Fri, 23 Nov 2007 03:53:17 +0100
From: Andi Kleen <andi@firstfloor.org>
To: David Chinner <dgc@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, Stewart Smith <stewart@mysql.com>,
       xfs-oss <xfs@oss.sgi.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9]: Reduce Log I/O latency
Message-ID: <20071123025317.GA12257@one.firstfloor.org>
References: <20071122003339.GH114266761__34694.2978365861$1195691722$gmane$org@sgi.com> <p73oddnhzoq.fsf@bingen.suse.de> <20071122011214.GR114266761@sgi.com> <1195702123.8369.78.camel@localhost.localdomain> <20071122120611.GA3573@one.firstfloor.org> <20071122131539.GX114266761@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071122131539.GX114266761@sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2007 at 12:15:39AM +1100, David Chinner wrote:
> On Thu, Nov 22, 2007 at 01:06:11PM +0100, Andi Kleen wrote:
> > > FWIW from a "real time" database POV this seems to make sense to me...
> > > in fact, we probably rely on filesystem metadata way too much
> > > (historically it's just "worked".... although we do seem to get issues
> > > on ext3).
> > 
> > For that case you really would need priority inheritance: any metadata
> > IO on behalf or blocking a process needs to use the process' block IO 
> > priority.
> 
> How do you do that when the processes are blocking on semaphores,
> mutexes or rw-semaphores in the fileysystem three layers removed from
> the I/O in progress?

[...] I didn't say it was easy (or rather explicitely said it would be tricky).
Probably it would be possible to fold it somehow into rt mutexes PI,
but it's not easy and semaphores would need to be handled too.

Just my point was to solve the metadata RT problem unconditionally increasing
the priority is a bad idea and not really a replacement to a "full"
solution. Short term a user can just increase the priority of all the XFS 
threads anyways.

-Andi
