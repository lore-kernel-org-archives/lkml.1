Return-Path: <linux-kernel-owner+w=401wt.eu-S1757372AbYAJW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372AbYAJW4S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 17:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753750AbYAJW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 17:56:08 -0500
Received: from phunq.net ([64.81.85.152]:36271 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751116AbYAJW4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 17:56:07 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Thu, 10 Jan 2008 14:55:32 -0800
User-Agent: KMail/1.9.5
Cc: Matt Mackall <mpm@selenic.com>,
       Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <200801100149.16301.phillips@phunq.net> <20080110113954.GL3510@agk.fab.redhat.com>
In-Reply-To: <20080110113954.GL3510@agk.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801101455.32927.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2008 03:39, Alasdair G Kergon wrote:
> On Thu, Jan 10, 2008 at 01:49:15AM -0800, Daniel Phillips wrote:
> > So what stops you from changing to unlocked_ioctl for the main
> > device mapper ctl_ioctl?
>
> Nothing - patches to do this are queued for 2.6.25:

Nice.  This removes a deadlock we hit, where if creating a device mapper 
target blocks indefinitely (say on network IO) then nobody else can 
complete a device mapper operation because BKL is held.  If completing 
the device create depends on some other device mapper operation, then 
it is game over.

Our current workaround is to test for and drop BKL, ugh.  Thanks for the 
cleanup.

Regards,

Daniel
