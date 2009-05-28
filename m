Return-Path: <linux-kernel-owner+w=401wt.eu-S1762019AbZE1IhY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019AbZE1IhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 04:37:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754377AbZE1IhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 04:37:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50500 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753946AbZE1IhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 04:37:08 -0400
Date: Thu, 28 May 2009 01:36:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <pierre@ossman.eu>
Cc: dsaxena@plexity.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Add 400ms to CAFE SD controller resume path
Message-Id: <20090528013629.0173522b.akpm@linux-foundation.org>
In-Reply-To: <20090522135150.7e0716d6@mjolnir.ossman.eu>
References: <20090513200556.GA7882@plexity.net>
	<20090522135150.7e0716d6@mjolnir.ossman.eu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 13:51:50 +0200 Pierre Ossman <pierre@ossman.eu> wrote:

> On Wed, 13 May 2009 20:05:56 +0000
> Deepak Saxena <dsaxena@plexity.net> wrote:
> 
> > 
> > The CAFE SD controller takes a long time to completely resume
> > and w/o this patch, we do not redetect an existing card but
> > instead detect it as a new one. Even with MMC_UNSAFE_RESUME
> > enabled, this leads to the partition table on the device being
> > wiped out.
> >     
> > See http://dev.laptop.org/ticket/6532 for gory details.

hm, this sounds like a fairly serious problem, but the patch is nearly
a year old.

> > Signed-off-by: Deepak Saxena <dsaxena@laptop.org>
> > 
> 
> Reading through that report, I don't believe you properly worked around
> the bug. You only avoid bug 1339, but that's only mildly related.
> 
> What this workaround does is to make sure that MMC_UNSAFE_RESUME
> actually works. But if you change cards during suspend, the VFS bug
> should reappear and you'll corrupt the partition table.

What do you think the VFS did wrong here?

> And as for 1339, has there been any more work done on why this problem
> doesn't appear in OFW? I'd be a lot happier if we could make things
> work without artificial delays.


