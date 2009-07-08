Return-Path: <linux-kernel-owner+w=401wt.eu-S1757546AbZGHG3C@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757546AbZGHG3C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:29:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZGHG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:28:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:59871 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbZGHG2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:28:53 -0400
Subject: Re: Possible memory leak in request_firmware()
From: David Woodhouse <dwmw2@infradead.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Sachin Sant <sachinp@in.ibm.com>
In-Reply-To: <d82e647a0907072138x106c48bdyfbc4dd884ad64b2c@mail.gmail.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
	 <20090707190125.61920d00@gondolin>
	 <1247003445.5710.7.camel@pc1117.cambridge.arm.com>
	 <d82e647a0907072138x106c48bdyfbc4dd884ad64b2c@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 08 Jul 2009 07:28:39 +0100
Message-Id: <1247034519.15903.3.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 12:38 +0800, Ming Lei wrote:
> 2009/7/8 Catalin Marinas <catalin.marinas@arm.com>:
> > On Tue, 2009-07-07 at 19:01 +0200, Cornelia Huck wrote:
> >
> > There is one more leak in this area which I couldn't figure out where it
> > should be freed:
> >
> > unreferenced object 0xc353e530 (size 512):
> >  comm "cat", pid 3130, jiffies 4294903232
> >  backtrace:
> >    [<c01e6f6a>] create_object+0xfa/0x250
> >    [<c01e753d>] kmemleak_alloc+0x5d/0x70
> >    [<c01e223d>] __kmalloc+0x10d/0x210
> >    [<c03b2d2f>] firmware_data_write+0x1df/0x270
> >    [<c024163a>] write+0x13a/0x1b0
> >    [<c01eae1c>] vfs_write+0x9c/0x190
> >    [<c01eafcd>] sys_write+0x3d/0x70
> >    [<c010319c>] sysenter_do_call+0x12/0x38
> >    [<ffffffff>] 0xffffffff
> >
> > Any idea? It looks like this is the kmalloc() in fw_realloc_buffer()
> > (inlined in firmware_data_write).
> 
> I guess the leak is introduced in commit :
>              commit	6e03a201bbe8137487f340d26aa662110e324b20
>              firmware: speed up request_firmware(), v3
> 
> The attachment patch may fix the leak, please test and verify it.
> Thanks.

I think you need to stop it from clearing fw_priv->nr_pages too.
With that change, it looks correct. Thanks.

Acked-by: David Woodhouse <David.Woodhouse@intel.com>

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

