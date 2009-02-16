Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZBPRcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZBPRcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 12:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbZBPRcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 12:32:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38280 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814AbZBPRcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:32:06 -0500
Message-ID: <4999A236.9040508@zytor.com>
Date: Mon, 16 Feb 2009 09:28:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, cpw@sgi.com
Subject: Re: #tj-percpu has been rebased
References: <49833350.1020809@kernel.org> <200902140728.55954.rusty@rustcorp.com.au> <4996141A.1050506@kernel.org> <200902161753.14141.rusty@rustcorp.com.au>
In-Reply-To: <200902161753.14141.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> 
> But note that for the non-NUMA case, you can just use kmalloc/__get_free_pages
> and no remapping tricks are necessary at all.
> 

Only if your chunks are really small.  Keep in mind that
num_possible_cpus() may be 4096, and so it is unlikely you'll be able to
get enough contiguous pages unless you're using the largepage pool, and
even then you only get 512 bytes per cpu.

All in all I think a dedicated virtual zone per CPU as opposed to
interleaving them seems to make more sense.  Even with 4096 CPUs and
reserving, say, 256 MB per CPU it's not that much address space in the
context of a 47-bit kernel space.  On 32 bits I don't think anything but
the most trivial amount of percpu space is going to fly no matter what.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

