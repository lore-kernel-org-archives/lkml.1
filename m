Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbXH1BNy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbXH1BNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbXH1BNp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:13:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:9132 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753165AbXH1BNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:13:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,314,1183359600"; 
   d="scan'208";a="289097373"
Subject: Re: [RFC][PATCH 2/2 -mm] kexec based hibernation: kexec restore
From: "Huang, Ying" <ying.huang@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
In-Reply-To: <20070827213134.GE3398@elf.ucw.cz>
References: <1188177296.3247.38.camel@caritas-dev.intel.com>
	 <20070827213134.GE3398@elf.ucw.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 28 Aug 2007 09:14:37 +0800
Message-Id: <1188263677.2050.8.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-OriginalArrivalTime: 28 Aug 2007 01:13:38.0096 (UTC) FILETIME=[A9CE3300:01C7E910]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-27 at 23:31 +0200, Pavel Machek wrote:
> Hi!
> 
> > This patch adds writing support for /dev/oldmem. This is used to
> > restore the memory contents of hibernated system.
> > 
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> 
> > +ssize_t write_oldmem_page(unsigned long pfn, const char *buf,
> > +			  size_t csize, unsigned long offset, int userbuf)
> 
> Hmm, int userbuf is only ever set to one... Does it make sense to have
> write_oldmem_page in the separate file? The onl user is mem.c, perhaps
> it should go there?
> 

write_oldmem_page is kept to be consistent with copy_oldmem_page as much
as possible. The userbuf is used by copy_oldmem_page too, and
write_oldmem_page is in the same file as copy_oldmem_page. I think the
consistence between them is reasonable.

And the copy_oldmem_page/write_oldmem_page is considered to be
architecture dependent. Now, there are different implementations for
copy_oldmem_page on different architectures. So I think the
copy_oldmem_page/write_oldmem_page should be kept in separate file
instead of go mem.c.

Best Regards,
Huang Ying
