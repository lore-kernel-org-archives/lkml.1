Return-Path: <linux-kernel-owner+w=401wt.eu-S1754954AbZKCVCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954AbZKCVCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:02:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754567AbZKCVCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:02:14 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46035 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278AbZKCVCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 16:02:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Dasgupta, Romit" <romit@ti.com>
Subject: Re: [PATCH 1/1] PM: Making bdi threads non-freezable
Date: Tue, 3 Nov 2009 22:03:57 +0100
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc5-rjw; KDE/4.3.1; x86_64; ; )
Cc: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EBC66@dbde02.ent.ti.com> <200911021943.49943.rjw@sisk.pl> <B85A65D85D7EB246BE421B3FB0FBB59301DE1EC179@dbde02.ent.ti.com>
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB59301DE1EC179@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911032203.57757.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 November 2009, Dasgupta, Romit wrote:
> 
> > Subject: Re: [PATCH 1/1] PM: Making bdi threads non-freezable
> > 
> > On Monday 02 November 2009, Dasgupta, Romit wrote:
> > > Fixes the case when bdi threads are in the refrigerator but file system sync
> > > can happen after this. This is possible in MMC when
> > CONFIG_MMC_UNSAFE_RESUME is
> > > not set.
> > 
> > What's going to happen if we attemt to suspend the underlying block device(s)
> > when the bdi thread are doing their job?  Is there any synchronisation
> > mechanism for that?
> > 
> There is no explicit synchronization AFAICT. However, it looks like the call
> to 'del_gendisk' would invoke 'sync_filesystem' down the line.
> 'sync_filesystem' would end with synchronous writes of inodes followed by a
> call to '__sync_blockddev'.

However, that runs concurrently with respect to the suspend thread, AFAICS, so
I wonder if there's anything to make the suspend thread wait for these
operations to complete.  If there's nothing like that, we can't really allow
the bdi threads to run in parallel with the suspend thread.

Thanks,
Rafael
