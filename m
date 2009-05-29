Return-Path: <linux-kernel-owner+w=401wt.eu-S1755711AbZE2Gsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755711AbZE2Gsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 02:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbZE2Gsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 02:48:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54494 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZE2Gsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 02:48:37 -0400
Date: Fri, 29 May 2009 15:47:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Maximum size of a swap partition
Message-Id: <20090529154701.8edf2deb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090529083054.d0cb6622.Christoph.Pleger@cs.tu-dortmund.de>
References: <20090528093117.87b190ed.Christoph.Pleger@cs.tu-dortmund.de>
	<20090529083054.d0cb6622.Christoph.Pleger@cs.tu-dortmund.de>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 May 2009 08:30:54 +0200
Christoph Pleger <Christoph.Pleger@cs.tu-dortmund.de> wrote:

> Hello,
> 
> > what is the maximum size of a swap partition with Kernel 2.6.26 on an
> > x86 and on an x86_64 machine? Some people say that it is 2GB on x86,
> > but that seems not to be true any more.
> 
> Is here, in the mailing list where the power of kernel knowledge
> resides, really no one able to answer that question within one day?
> 
Mailing list is not a place where a kind man reads all e-mails every day.

At first, start from man. man mkswap says.
==
      The maximum useful size of a swap area depends on the architecture  and
       the  kernel  version.  It is roughly 2GiB on i386, PPC, m68k, ARM, 1GiB
       on sparc, 512MiB on mips, 128GiB on alpha and 3TiB on sparc64. For ker-
       nels after 2.3.3 there is no such limitation.
==
 For kernels after 2.3.3 there is no such limitation.

>From code,
==
union swap_header {
        struct {
                char reserved[PAGE_SIZE - 10];
                char magic[10];                 /* SWAP-SPACE or SWAPSPACE2 */
        } magic;
        struct {
                char            bootbits[1024]; /* Space for disklabel etc. */
                __u32           version;
                __u32           last_page;
                __u32           nr_badpages;
                unsigned char   sws_uuid[16];
                unsigned char   sws_volume[16];
                __u32           padding[117];
                __u32           badpages[1];
        } info;
};
==

last_page represents the size of a swap partition.

Then, 
  UINT_MAX * PAZE_SIZE = 16Tbytes ? is a limitation for a swap device.
  you can use 30 swap devices now.

I'm not sure whether there are other limitations. But maybe enough big.

Bye,
-Kame


