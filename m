Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbZBYShD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbZBYShD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 13:37:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754792AbZBYSgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 13:36:52 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:45719 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772AbZBYSgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 13:36:51 -0500
Subject: Re: btrfs: warn_slowpath in clean_tree_block and others
From: Chris Mason <chris.mason@oracle.com>
To: Hugo Mills <hugo-lkml@carfax.org.uk>
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090224230249.GA6859@vlad.carfax.org.uk>
References: <20090224230249.GA6859@vlad.carfax.org.uk>
Content-Type: text/plain
Date: Wed, 25 Feb 2009 13:36:26 -0500
Message-Id: <1235586986.32346.48.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.49A58FAE.0141:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-02-24 at 23:02 +0000, Hugo Mills wrote:
> This is essentially a repost of a mail I made last week, to which I
> didn't get a reply.
> 

Sorry I missed replying to this one last week, thanks for resending.

>    I'm getting huge numbers of kernel warnings whilst using
> btrfs. They're all "warn_slowpath", and all seem to be in
> fs/btrfs/disk-io.c. I've included one typical example at the end of
> this mail.
> 
>    Kernel versions are 2.6.29-rc2, -rc4 and -rc6.
> 

The warnings look like i386, exactly what hardware is this?  Is your
kernel compiled for SMP or UP?

The warning you're getting is that clean_tree_block expects this block
to be locked, and giving out a warning because it is showing up as
unlocked.

So, hopefully you're on a UP kernel and my test for a locked spinlock is
broken in that config.

-chris


