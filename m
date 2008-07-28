Return-Path: <linux-kernel-owner+w=401wt.eu-S1758174AbYG1Sjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758174AbYG1Sjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753311AbYG1Sj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:39:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55545 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbYG1Sj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:39:28 -0400
Date: Mon, 28 Jul 2008 12:39:11 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       stephen@blacksapphire.com, benm@symmetric.co.nz, jkosina@suse.cz
Subject: Re: warning in scheduler
Message-ID: <20080728183911.GC16059@parisc-linux.org>
References: <1217214947.11188.156.camel@pasglop> <1217238791.6331.15.camel@twins> <1217239403.11188.189.camel@pasglop> <20080728100752.GA4717@elte.hu> <1217241622.11188.191.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217241622.11188.191.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 08:40:22PM +1000, Benjamin Herrenschmidt wrote:
> I tend to agree. I might look into doing it for powerpc around rc3 or
> so, when things have settled a bit.

It'd be nice if allmodconfig even compiled:

drivers/char/pcmcia/ipwireless/hardware.c:571: error: invalid use of undefined type 'struct ipw_network'

Not to mention the qla_attr patch:

+#include <linux/delay.h>

There's probably others, I just haven't got far enough in the
compilation process yet.

But I am seeing lots of warnings _without_ the patch applied:

fs/omfs/inode.c: In function 'omfs_fill_super':
fs/omfs/inode.c:495: warning: format '%llx' expects type 'long long
unsigned int', but argument 2 has type 'u64'
fs/proc/base.c: In function 'do_io_accounting':
fs/proc/base.c:2429: warning: format '%llu' expects type 'long long
unsigned int', but argument 3 has type 'u64'
fs/ubifs/dir.c: In function 'ubifs_readdir':
fs/ubifs/dir.c:437: warning: format '%llu' expects type 'long long
unsigned int', but argument 5 has type '__le64'

(other warnings snipped for brevity).

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
