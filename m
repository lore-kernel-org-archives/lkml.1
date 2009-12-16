Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbZLPUrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbZLPUrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751539AbZLPUr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:47:28 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:41449 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbZLPUr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:47:27 -0500
From: Roger Oksanen <roger.oksanen@cs.helsinki.fi>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: e100 REGRESSION in 2.6.32
Date: Wed, 16 Dec 2009 22:46:49 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.32-ironman-1; KDE/4.3.4; i686; ; )
Cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
References: <Pine.LNX.4.44L0.0912161447260.2643-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912161447260.2643-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Message-Id: <200912162246.49611.roger.oksanen@cs.helsinki.fi>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 December 2009 21:50:38 Alan Stern wrote:
> On Wed, 16 Dec 2009, Brandeburg, Jesse wrote:
> >  Alan thanks for the report, I wonder if 
> > you can revert 98468efddb101f8a29af974101c17ba513b07be1 and see if that 
> > fixes it?
> 
> It does indeed.  Thanks for the quick response.
> 
> > Roger on the To: line made that change, which may have broken e100 for 
> > your system.
> 
> It looks simple enough, but obviously something is wrong with it.

I'm looking into this. Quite a baffling problem though. I have no idea what
causes the last 4 bytes  to change slightly (6c 6b 6b a3). Perhaps the patch 
only changed the timings to uncloak a lurking bug.. 
struct sk_buff has users as it's last member, so perhaps there is a preempt
point in dmapool that triggers a race with the rx path.

I'll try to reproduce this..

-- 
Roger Oksanen <roger.oksanen@cs.helsinki.fi>
http://www.cs.helsinki.fi/u/raoksane
+358 50 355 1990
