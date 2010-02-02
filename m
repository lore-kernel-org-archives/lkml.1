Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab0BBRUc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 12:20:32 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33766 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756679Ab0BBRUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 12:20:30 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Oliver Neukum <oliver@neukum.org>,
       Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1002021208100.1805-100000@iolanthe.rowland.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 17:20:11 +0000
Message-Id: <1265131212.12634.112.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 17:20:13.0104 (UTC) FILETIME=[FAC1E300:01CAA42B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 17:11 +0000, Alan Stern wrote:
> On Tue, 2 Feb 2010, Oliver Neukum wrote:
> 
> > Am Dienstag, 2. Februar 2010 13:39:35 schrieb Catalin Marinas:
> > > > For storage that is correct. But what about other sources of pages,
> > > > for example iSCSI?
> > >
> > > In the iSCSI case, does the HCD driver write directly to a page cache
> > > page? Or it just fills in network packets that are copied to page cache
> > > pages by the iSCSI code (sorry, I'm not familiar with this part of the
> > > kernel). If the latter, the cache flushing in the HCD driver would not
> > > help and it needs to be done in the iSCSI code.
> >
> > As far as I can tell iSCSI does a private copy. But I don't know how
> > many methods to transfer code pages over USB exist. I'd say the
> > conservative solution is to flush for everything but control transfers.
> 
> This doesn't make any sense.  Nobody would ever use isochronous
> transfers to store data into a code page because isochronous is
> unreliable.  (Audio isn't a counterexample -- audio data may be mapped
> to userspace, but only to data pages, not code pages.  And the problem
> here is to maintain consistency between the D and I caches.)

My issues is with both I-D coherency and D-cache aliasing caused by
pages mapped in both user and kernel space (with different colours). The
flush_dcache_page() call should target both cases.

-- 
Catalin

