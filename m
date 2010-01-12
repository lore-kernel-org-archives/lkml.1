Return-Path: <linux-kernel-owner+w=401wt.eu-S1751784Ab0ALGAK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab0ALGAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 01:00:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180Ab0ALGAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 01:00:09 -0500
Received: from mail.gmx.net ([213.165.64.20]:49082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751070Ab0ALGAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 01:00:08 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19EN1d+MgpEA5wK0FeisX1/ZhzWwIV+2/fO6xew09
	cZu/hgloE2tVf7
Subject: Re: 2.6.33 pagemap endless read loop
From: Mike Galbraith <efault@gmx.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100110123702.GC25323@basil.fritz.box>
References: <20100110020955.GB25323@basil.fritz.box>
	 <20100110063335.GA3005@hack>  <20100110123702.GC25323@basil.fritz.box>
Content-Type: text/plain
Date: Tue, 12 Jan 2010 06:59:59 +0100
Message-Id: <1263275999.5987.26.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-10 at 13:37 +0100, Andi Kleen wrote:
> > Are you sure
> 
> I don't know if it's really endless, but it's doing a good emulation
> of it if it's not.
> 
> > 
> > On my 32bit machine, it runs for a long time, but finally exits.
> 
> That was on 64bit.
> 
> proc01 had accumulated several minutes of CPU time when I stopped it.
> 
> > From the document of pagemap, it is the mapping of all the virtual pages
> > of a process, on x86-32, it should be 4G/4K = 1024*1024 pages, also
> 
> Only the mapped ones surely?
> 
> Right now it looks like it dumps all the holes and that obviously
> will never finish on 64bit which has 47bits of address space.

Takes forever if you whack .pagemap_pte_hole too, just spends it's life
in pagemap_pte_range() instead.

start_vaddr:0x0 end_vaddr:0x7ffffffff000

Hm, zillion paces ain't a walk.

	-Mike

