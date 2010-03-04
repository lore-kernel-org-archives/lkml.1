Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756924Ab0CDTXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 14:23:52 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49064 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235Ab0CDTXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 14:23:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while userspace is frozen?
Date: Thu, 4 Mar 2010 20:26:30 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-git-rjw; KDE/4.3.5; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1003032142580.6963-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003042026.30303.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 March 2010, Alan Stern wrote:
> On Thu, 4 Mar 2010, Rafael J. Wysocki wrote:
> 
> > > Very well.  Then we still need a solution to the original problem:  
> > > Devices sometimes need to be unregistered during resume, but
> > > del_gendisk() blocks on the writeback thread, which is frozen until
> > > after the resume finishes.  How do you suggest this be fixed?
> > 
> > I thought about thawing the writeback thread earlier in such cases.
> > 
> > Would that makes sense / is it doable at all?
> 
> My thought exactly.  This is the only approach that also solves the 
> following race:
> 
> 	A driver is unloaded at the same time as a suspend starts.
> 
> 	The writeback thread gets frozen.
> 
> 	Then before the rmmod thread is frozen, it calls del_gendisk.
> 
> Delaying things by means of a workqueue (or the equivalent) might also 
> work, but it doesn't seem as safe.  For example, some important 
> writebacks might end up getting delayed until too late.

OK, so what exactly should trigger the thawing of the writeback thread?

Should we do that unconditionally at one point or wait for a specific situation
to happen, and how to recognize that situation in the latter case?

Rafael
