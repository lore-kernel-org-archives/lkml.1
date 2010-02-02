Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0BBOee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 09:34:34 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:49910 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754548Ab0BBOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 09:34:28 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Catalin Marinas <catalin.marinas@arm.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sebastian Siewior <bigeasy@linutronix.de>, Greg KH <greg@kroah.com>
In-Reply-To: <201002021408.51851.oliver@neukum.org>
References: <20100129185434.GH19501@one-eyed-alien.net>
	 <201002021307.56991.oliver@neukum.org>
	 <1265114375.12634.61.camel@pc1117.cambridge.arm.com>
	 <201002021408.51851.oliver@neukum.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Tue, 02 Feb 2010 14:34:14 +0000
Message-Id: <1265121254.12634.74.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Feb 2010 14:34:15.0653 (UTC) FILETIME=[CBA77150:01CAA414]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-02 at 13:08 +0000, Oliver Neukum wrote:
> Am Dienstag, 2. Februar 2010 13:39:35 schrieb Catalin Marinas:
> > > For storage that is correct. But what about other sources of pages,
> > > for example iSCSI?
> >
> > In the iSCSI case, does the HCD driver write directly to a page cache
> > page? Or it just fills in network packets that are copied to page cache
> > pages by the iSCSI code (sorry, I'm not familiar with this part of the
> > kernel). If the latter, the cache flushing in the HCD driver would not
> > help and it needs to be done in the iSCSI code.
> 
> As far as I can tell iSCSI does a private copy. But I don't know how
> many methods to transfer code pages over USB exist. I'd say the
> conservative solution is to flush for everything but control transfers.

flush_dcache_page() is on many architectures implemented lazily so that
if the page isn't mapped in user space no flushing takes place. It's
mainly the cost of virt_to_page() which I suspect is slightly higher
with sparsemem enabled.

-- 
Catalin

