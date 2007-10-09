Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbXJIOFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbXJIOFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 10:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752952AbXJIOE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 10:04:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42719 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbXJIOE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 10:04:58 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "huang ying" <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH -mm -v4 1/3] i386/x86_64 boot: setup data
Date: Tue, 9 Oct 2007 16:04:49 +0200
User-Agent: KMail/1.9.6
Cc: "Nick Piggin" <nickpiggin@yahoo.com.au>,
       "Huang, Ying" <ying.huang@intel.com>, linux-mm@kvack.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, akpm@linux-foundation.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>,
       "Chandramouli Narayanan" <mouli@linux.intel.com>,
       linux-kernel@vger.kernel.org
References: <1191912010.9719.18.camel@caritas-dev.intel.com> <200710091313.45003.ak@suse.de> <851fc09e0710090700u21b2db91yca2d5e88cb7a502a@mail.gmail.com>
In-Reply-To: <851fc09e0710090700u21b2db91yca2d5e88cb7a502a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710091604.50263.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 October 2007 16:00:57 huang ying wrote:
> On 10/9/07, Andi Kleen <ak@suse.de> wrote:
> >
> > > Care to add a line of documentation if you keep it in mm/memory.c?
> >
> > It would be better to just use early_ioremap() (or ioremap())
> >
> > That is how ACPI who has similar issues accessing its tables solves this.
> 
> Yes. That is another solution. But there is some problem about
> early_ioremap (boot_ioremap, bt_ioremap for i386) or ioremap.
> 
> - ioremap can not be used before mem_init.
> - For i386, boot_ioremap can map at most 4 pages, bt_ioremap can map
> at most 16 pages. This will be an unnecessary constrains for size of
> setup_data.

That could be easily extended if needed. But I don't see why we would
need that much setup data anyways. Limiting it to let's say 16KB
seems entirely reasonable. And if some kernel ever needs more it can 
be still extended.

The biggest item is probably the command line and i don't see why
that should be more than a one or two KB.

> - For i386, the virtual memory space of ioremap is limited too.

That will be all freed and again the data shouldn't be that big.

-Andi

 
