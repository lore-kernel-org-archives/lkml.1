Return-Path: <linux-kernel-owner+w=401wt.eu-S932778AbXGRLkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932778AbXGRLkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 07:40:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757337AbXGRLke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 07:40:34 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:1153 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321AbXGRLkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 07:40:33 -0400
Date: Wed, 18 Jul 2007 13:40:13 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Gabriel C <nix.or.die@googlemail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>, gregkh@suse.de,
       miles.lane@gmail.com
Subject: Re: [PATCH] sysfs: cosmetic clean up on node creation failure paths
Message-ID: <20070718134013.057e4755@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <20070718073811.GA22374@htj.dyndns.org>
References: <469A5C94.7030201@googlemail.com>
	<a781481a0707151414l3efcd2d0q93db88a32b90e344@mail.gmail.com>
	<469A9D5D.10509@googlemail.com>
	<469B61C8.8010902@googlemail.com>
	<a781481a0707160819w1be9128cxb3cdd06ba068b20d@mail.gmail.com>
	<469BB7B8.3060002@gmail.com>
	<469BB9CA.6090500@googlemail.com>
	<469BC2D6.5090008@googlemail.com>
	<469BC34C.4080107@googlemail.com>
	<20070718071445.GI23568@htj.dyndns.org>
	<20070718073811.GA22374@htj.dyndns.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Jul 2007 16:38:11 +0900,
Tejun Heo <htejun@gmail.com> wrote:

> Node addition failure is detected by testing return value of
> sysfs_addfm_finish() which returns the number of added and removed
> nodes.  As the function is called as the last step of addition right
> on top of error handling block, the if blocks looked like the
> following.
> 
> 	if (sysfs_addrm_finish(&acxt))
> 		success handling, usually return;
> 	/* fall through to error handling */
> 
> This is the opposite of usual convention in sysfs and makes the code
> difficult to understand.  This patch inverts the test and makes those
> blocks look more like others.
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> ---
>  fs/sysfs/dir.c     |   12 +++++++-----
>  fs/sysfs/file.c    |    9 +++++----
>  fs/sysfs/symlink.c |   10 ++++++----
>  3 files changed, 18 insertions(+), 13 deletions(-)

Looks nice. One thing, though:

sysfs_hash_and_remove() has the same check, but without a cleanup
section. This should follow the (!sysfs_addrm_finish()) pattern as well
(makes pattern matching easier when reading the code).
