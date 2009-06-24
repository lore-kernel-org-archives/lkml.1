Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbZF0LaO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbZF0LaO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 07:30:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZF0LaC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 07:30:02 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41028 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZF0LaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 07:30:00 -0400
Date: Wed, 24 Jun 2009 17:05:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Joseph Cihula <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, arjan@linux.intel.com,
       hpa@zytor.com, andi@firstfloor.org, chrisw@sous-sol.org,
       jmorris@namei.org, jbeulich@novell.com, peterm@redhat.com,
       gang.wei@intel.com, shane.wang@intel.com
Subject: Re: [RFC v5][PATCH 4/4] intel_txt: force IOMMU on for Intel(R) TXT
	launch
Message-ID: <20090624150536.GL1784@ucw.cz>
References: <4A4024C5.3020702@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4024C5.3020702@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-22 17:41:41, Joseph Cihula wrote:
> The tboot module will DMA protect all of memory in order to ensure the that
> kernel will be able to initialize without compromise (from DMA).  Consequently,
> the kernel must enable Intel(R) Virtualization Technology for Directed I/O
> (VT-d or Intel IOMMU) in order to replace this broad protection with the
> appropriate page-granular protection.  Otherwise DMA devices will be unable
> to read or write from memory and the kernel will eventually panic.
> 
> Because runtime IOMMU support is configurable by command line options, this
> patch will force it to be enabled regardless of the options specified, and will
> log a message if it was required to force it on.
> 
> 
>  dmar.c        |    8 ++++++++
>  intel-iommu.c |   28 ++++++++++++++++++++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)

This needs documentation. And you probably should panic the kernel if
user passes unworkable options, not override his choices.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
