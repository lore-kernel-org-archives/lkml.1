Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbYCLUCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbYCLUCl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 16:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbYCLUC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 16:02:28 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:57632
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154AbYCLUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 16:02:27 -0400
Message-ID: <47D844B5.2090001@microgate.com>
Date: Wed, 12 Mar 2008 15:01:41 -0600
From: Paul Fulghum <paulkf@microgate.com>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: rupesh.sugathan@gmail.com
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: + n_tty-loss-of-sync-following-a-buffer-overflow.patch added
 to -mm tree
References: <200803120455.m2C4t4Aw010881@imap1.linux-foundation.org>	 <20080312102729.58956d2c@the-village.bc.nu>	 <47D7F531.2070400@microgate.com>  <1205339539.8873.14.camel@estonia> <1205343590.4094.17.camel@x2.microgate.com>
In-Reply-To: <1205343590.4094.17.camel@x2.microgate.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Fulghum wrote:
> What I suggest is the following patch for processing NL
> in canonical mode.

FYI:

I tested my patch by provoking the bug with
a contrived pair of programs. Everything works
as expected. Partially receive lines during buffer
overflow are truncated. Subsequent lines after the
ldisc buffer clears are intact, canon_data stays
consistent with read_flags.

*But* to force the bug I had to disable the
check in flush_to_ldisc() that monitors the
amount of receive room in the ldisc buffer
before pushing data to the ldisc. This check
was introduced in the flip buffer rewrite in 2.6

So the bug is real, the fix works, but in 2.6.24
this can never occur as the flip buffer holds data
until N_TTY is ready to process it.

Rupesh is working with 2.4.x which shares the
same canonical NL processing but has the old
flip buffer code that shoves data at N_TTY without
regard for the receive room in N_TTY.

I leave it to others to decide if applying the
patch to 2.6 makes sense.

-- 
Paul Fulghum
Microgate Systems, Ltd.
