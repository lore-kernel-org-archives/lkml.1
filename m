Return-Path: <linux-kernel-owner+w=401wt.eu-S1755494AbZBPXWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbZBPXWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 18:22:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751799AbZBPXWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 18:22:33 -0500
Received: from ozlabs.org ([203.10.76.45]:50997 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbZBPXWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 18:22:32 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: #tj-percpu has been rebased
Date: Tue, 17 Feb 2009 09:52:20 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
References: <49833350.1020809@kernel.org> <200902161753.14141.rusty@rustcorp.com.au> <4999A236.9040508@zytor.com>
In-Reply-To: <4999A236.9040508@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902170952.21063.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 February 2009 03:58:22 H. Peter Anvin wrote:
> Rusty Russell wrote:
> > 
> > But note that for the non-NUMA case, you can just use kmalloc/__get_free_pages
> > and no remapping tricks are necessary at all.
> > 
> 
> Only if your chunks are really small.  Keep in mind that
> num_possible_cpus() may be 4096, and so it is unlikely you'll be able to
> get enough contiguous pages unless you're using the largepage pool, and
> even then you only get 512 bytes per cpu.
> 
> All in all I think a dedicated virtual zone per CPU as opposed to
> interleaving them seems to make more sense.  Even with 4096 CPUs and
> reserving, say, 256 MB per CPU it's not that much address space in the
> context of a 47-bit kernel space.  On 32 bits I don't think anything but
> the most trivial amount of percpu space is going to fly no matter what.

It's the TLB cost which I really don't want to pay; num_possible_cpus()
4096 non-NUMA is a little silly (currently impossible).

I'm happy to limit per-cpu allocations to pagesize, then you only need to
find num_possible_cpus() contig pages, and if you can't, you fall back to
vmalloc.

Thanks,
Rusty.
