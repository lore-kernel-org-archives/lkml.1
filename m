Return-Path: <linux-kernel-owner+w=401wt.eu-S1757349AbYAJJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349AbYAJJtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753041AbYAJJtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:49:32 -0500
Received: from phunq.net ([64.81.85.152]:46616 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752463AbYAJJtb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:49:31 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Thu, 10 Jan 2008 01:49:15 -0800
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <1199909560.6245.67.camel@cinder.waste.org> <20080109224026.GA4039@agk.fab.redhat.com>
In-Reply-To: <20080109224026.GA4039@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801100149.16301.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alasdair,

On Wednesday 09 January 2008 14:40, Alasdair G Kergon wrote:
> Device-mapper for example in dm_blk_ioctl(), has no need for BKL so
> drops it immediately, but it does need the inode parameter, so it is
> unable to switch as things stand.

So what stops you from changing to unlocked_ioctl for the main device 
mapper ctl_ioctl?  You aren't using the inode parameter, or the file 
parameter:

   http://lxr.linux.no/linux+v2.6.23.12/drivers/md/dm-ioctl.c#L1402

Regards,

Daniel
