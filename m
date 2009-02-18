Return-Path: <linux-kernel-owner+w=401wt.eu-S1755889AbZBRV1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755889AbZBRV1n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:27:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbZBRV1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:27:34 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:43184 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZBRV1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:27:33 -0500
Subject: Re: What can OpenVZ do?
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       viro@zeniv.linux.org.uk, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de, xemul@openvz.org
In-Reply-To: <20090218181644.GD19995@elte.hu>
References: <20090212114207.e1c2de82.akpm@linux-foundation.org>
	 <1234475483.30155.194.camel@nimitz>
	 <20090212141014.2cd3d54d.akpm@linux-foundation.org>
	 <20090213105302.GC4608@elte.hu> <1234817490.30155.287.camel@nimitz>
	 <20090217222319.GA10546@elte.hu> <1234909849.4816.9.camel@nimitz>
	 <20090218003217.GB25856@elte.hu> <1234917639.4816.12.camel@nimitz>
	 <20090218051123.GA9367@x200.localdomain>  <20090218181644.GD19995@elte.hu>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 13:27:27 -0800
Message-Id: <1234992447.26788.12.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 19:16 +0100, Ingo Molnar wrote:
> Nothing motivates more than app designers complaining about the 
> one-way flag.
> 
> Furthermore, it's _far_ easier to make a one-way flag SMP-safe. 
> We just set it and that's it. When we unset it, what do we about 
> SMP races with other threads in the same MM installing another 
> non-linear vma, etc.

After looking at this for file descriptors, I have to really agree with
Ingo on this one, at least as far as the flag is concerned.  I want to
propose one teeny change, though:  I think the flag should be
per-resource.

We should have one flag in mm_struct, one in files_struct, etc...  The
task_is_checkpointable() function can just query task->mm, task->files,
etc...  This gives us nice behavior at clone() *and* fork that just
works.

I'll do this for files_struct and see how it comes out so you can take a
peek.

-- Dave

