Return-Path: <linux-kernel-owner+w=401wt.eu-S935100AbYBUWNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935100AbYBUWNd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932973AbYBUWNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:13:04 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:16411 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764869AbYBUWNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:13:01 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Joel Becker <Joel.Becker@oracle.com>,
       Jody Belka <lists-lkml@pimb.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andi Kleen <andi@firstfloor.org>,
       Mika Penttila <mika.penttila@kolumbus.fi>
In-Reply-To: <47BDEF36.8000903@goop.org>
References: <20080212235404.GY7980@pimb.org> <47B2DBA5.6030001@goop.org>
	 <20080214022744.GA4160@mail.oracle.com> <47B3F2DC.8080707@goop.org>
	 <20080215202336.GE26034@mail.oracle.com>
	 <1203274161.27987.6.camel@localhost.localdomain>
	 <20080218104025.GA15899@ca-server1.us.oracle.com>
	 <1203458366.26910.15.camel@cthulhu.hellion.org.uk>
	 <47BBDA20.8030105@zytor.com>
	 <1203497511.26910.39.camel@cthulhu.hellion.org.uk>
	 <47BCA275.7000504@goop.org>
	 <1203546597.26910.74.camel@cthulhu.hellion.org.uk>
	 <47BDEA11.6010302@goop.org> <47BDEB57.5040203@zytor.com>
	 <47BDEF36.8000903@goop.org>
Content-Type: text/plain
Date: Thu, 21 Feb 2008 22:12:36 +0000
Message-Id: <1203631956.28436.4.camel@cthulhu.hellion.org.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: 2.6.25-rc1 xen pvops regression
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=qcrRp5rlbqkS0d6TfuPTVw==:17 a=xNZ4JnfWWoDiQ0WoWREA:9 a=GurOHIFMJbuUkp6txiUA:7 a=DxvAq27qi8HCbjRcIwniMl324IgA:4 a=WuK_CZDBSqoA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-21 at 13:37 -0800, Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
> >> Still curious about why a pagetable page is ending up in that range 
> >> though.  Seems like it shouldn't be possible, since we shouldn't be 
> >> allowed to allocate from those pages, at least until the DMI probe 
> >> has happened...  Unless the early allocator is only excluded from 
> >> e820 reserved pages, which would cause a problem on systems which 
> >> don't reserve the DMI space...  HPA?
> >>
> >
> > I thought the problem was a Xen-provided pagetable from before Linux 
> > started? 
> 
> Hm, I don't think so.  The domain-builder pagetable is put after the 
> kernel, so it shouldn't be under 1M.

I can confirm that it is Linux which is allocating it. The call path:
        # xm create -c debian-x86_32p-1
        Using config file "/etc/xen/debian-x86_32p-1".
        Started domain debian-1
        xen_alloc_pt_init PFN f0
        Pid: 0, comm: swapper Not tainted 2.6.25-rc2 #68
         [<c02ecb6b>] xen_alloc_pt_init+0x4b/0x60
         [<c02f5e2b>] one_page_table_init+0x8b/0xf0
         [<c02f63df>] paging_init+0x3bf/0x520
         [<c02ee444>] setup_arch+0x2a4/0x410
         [<c02e9a64>] start_kernel+0x64/0x380
         [<c02efd7f>] cpu_detect+0x6f/0xf0
         [<c02ed1a1>] xen_start_kernel+0x2f1/0x310
         =======================
        Entering add_active_range(0, 0, 262144) 0 entries of 256 used
        Zone PFN ranges:
          DMA             0 ->     4096

Ian.
> 
>     J
> 
-- 
Ian Campbell

Why do they call a fast a fast, when it goes so slow?

