Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYEaX5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYEaX5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 19:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbYEaX5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 19:57:12 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:35774 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754423AbYEaX5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 19:57:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=mindspring.com;
  b=EXOjd1XKJwKv/VDQWyZnau3ZHuNKmPMiCAmRn8pBXFK3MlmnOcnN39PclQwps76G;
  h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-ELNK-Trace:X-Originating-IP;
Date: Sat, 31 May 2008 19:57:02 -0400
From: Bill Fink <billfink@mindspring.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: James Cammarata <jimi@sngx.net>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Netdev List <netdev@vger.kernel.org>
Subject: Re: [PATCH] net: add ability to clear stats via ethtool -
 e1000/pcnet32
Message-Id: <20080531195702.0b879dd1.billfink@mindspring.com>
In-Reply-To: <20080531131143.516ca56e@core>
References: <482DA5B6.1020606@sngx.net>
	<482DB46A.8020103@cosmosbay.com>
	<482EF192.4070707@sngx.net>
	<482F5113.5090703@cosmosbay.com>
	<482F610D.2080108@sngx.net>
	<20080518003104.GK28241@solarflare.com>
	<482FBA09.80201@sngx.net>
	<483E0AAE.2020107@sngx.net>
	<20080528221118.63da4092.akpm@linux-foundation.org>
	<483EA2D1.8050603@sngx.net>
	<20080529154525.3916c7b5@core>
	<20080530151250.b44a119a.billfink@mindspring.com>
	<20080531131143.516ca56e@core>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.8.6; powerpc-yellowdog-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ELNK-Trace: c598f748b88b6fd49c7f779228e2f6aeda0071232e20db4d03a63f5c4e3ea5ba0f731dd4d129adee350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 96.234.158.248
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Alan Cox wrote:

> > When diagnosing network problems, the ability to zero counters is
> > a major aid in diagnosis.  Writing scripts is not a general solution
> > since often several systems are involved and it's not simple to do
> > this via a script.  Saving stats output and running beforeafter on
> > a number of systems is a royal pain when troubleshooting.
> 
> Zeroing them is not a general solution either - you break all the other
> tools monitoring the same stats in parallel - like network usage monitors.
> 
> This is a user space tools problem, scripts or otherwise.

Two points.  One, if I as a Linux network administrator, make a
deliberate decision to zero counters, I will be making that decision
taking into account any other effects it might have.

Second, I already expressed support for the preferred option of
the zeroing of counters actually just doing a snapshot of the stats,
and subsequent requests for the stats doing a diff from the snapshot.
There could also be a mechanism for getting the absolute values of
the stats that for example SNMP monitoring would utilize.

Perhaps a user space tool such as ifstat can be part of the solution
(I haven't had a chance to check it out yet).  But it would be
difficult I believe to make a general user space tool for dealing
with the device specific stats reported by "ethtool -S" since they
are quite specific to an individual device driver.

Yes, every individual Linux network administrator can re-create the
wheel by devising their own scripts, but it makes much more sense
to me to implement a simple general kernel mechanism once that could
be used generically, than to have hundreds (or thousands) of Linux
network administrators each having to do it themselves (perhaps
multiple times if they have a variety of types of systems and types
of NICs).

						-Bill
