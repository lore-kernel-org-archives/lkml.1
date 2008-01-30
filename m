Return-Path: <linux-kernel-owner+w=401wt.eu-S1758571AbYA3WkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571AbYA3WkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 17:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754588AbYA3WkE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 17:40:04 -0500
Received: from smtp1.cc.lut.fi ([157.24.2.30]:45945 "EHLO smtp1.cc.lut.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbYA3WkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 17:40:01 -0500
Date: Thu, 31 Jan 2008 00:39:01 +0200
From: Pekka Paalanen <pq@iki.fi>
To: tglx@linutronix.de
Cc: Pekka Paalanen <pq@iki.fi>, mingo@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86: mmiotrace - trace memory mapped IO
Message-ID: <20080131003901.763449fb@daedalus.pq.iki.fi>
In-Reply-To: <20080127195536.50809974@daedalus.pq.iki.fi>
References: <20080127185238.4bcac54b@daedalus.pq.iki.fi>
	<20080127195536.50809974@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Jan 2008 19:55:36 +0200
Pekka Paalanen <pq@iki.fi> wrote:

> The following is a copy of the patch description:
...
> Mmiotrace works by wrapping the ioremap family of kernel functions and
> marking the returned pages as not present. Access to the IO memory
> triggers a page fault, which will be handled by mmiotrace's custom page
> fault handler. This will single-step the faulted instruction with the
> MMIO page marked as present. Access logs are directed to user space via
> relay and debug_fs.

Hi,

a test user found a problem with mmiotrace (ported to x86/mm git tree).
The symbol 'init_mm' is undefined, but required when building the 32-bit
mmiotrace kernel module.

commit 3abf024d2abb79614d8c4cb25a70d5596f77d0ad
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Wed Jan 30 13:30:28 2008 +0100

    x86: nuke a ton of unused exports

This commit removes EXPORT_SYMBOL(init_mm). Apparently mmiotrace requires
this symbol, but I do not know why. I do not use init_mm myself, so
apparently some function I call is inlined and requires it. Page table or
attribute handling stuff maybe?

Is it possible to simply put back this export or should I dig deeper into
why it seems to be required?
I can provide the simple patch to put it back in my next patch set, if
this is the right solution.

I will post the patch set after this issue is solved. In the mean time,
for the interested, the current patches are here:
http://jumi.lut.fi/~paalanen/scratch/mmio25/


Ps. I tested x86/mm version of mmiotrace on my 64-bit system and it seems
to work ok. I had to write a simple test module because I did not have any
drivers that a) called ioremap, b) were not broken on x86/mm, and c) I
had the hardware to actually use it. So this testing is very light.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
