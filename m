Return-Path: <linux-kernel-owner+w=401wt.eu-S1756121AbYF1KCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121AbYF1KCP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 06:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYF1KCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 06:02:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56322 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621AbYF1KCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 06:02:01 -0400
Subject: Re: linux-next: Tree for June 26
From: Jaswinder Singh <jaswinder@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: David Woodhouse <david.woodhouse@intel.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       kernel-testers@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       "Maciej W. Rozycki" <macro@linux-mips.org>
In-Reply-To: <200806280104.17527.rjw@sisk.pl>
References: <20080627010842.e1a0c4b5.sfr@canb.auug.org.au>
	 <200806270138.53895.rjw@sisk.pl>
	 <1214563913.10393.180.camel@pmac.infradead.org>
	 <200806280104.17527.rjw@sisk.pl>
Content-Type: text/plain; charset=utf8
Date: Sat, 28 Jun 2008 15:24:23 +0530
Message-Id: <1214646863.2660.22.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello ﻿Rafael,

I am really sorry for inconvenience.

I do not have this hardware around me to test this patch.
I really need your help to figure out where is problem.

On Sat, 2008-06-28 at 01:04 +0200, Rafael J. Wysocki wrote:
> On Friday, 27 of June 2008, David Woodhouse wrote:
> > On Fri, 2008-06-27 at 01:38 +0200, Rafael J. Wysocki wrote:
> > > commit 423c982fffb1cd95c8cdd654ce5ab59351ba41f5
> > > Author: Jaswinder Singh <jaswinder@infradead.org>
> > > Date:   Wed Jun 18 19:58:33 2008 +0530
> > > 
> > >     firmware: convert tg3 driver to request_firmware()
> > > 
> > > breaks my nx6325.
> > > 
> > > Apparently, with this patch applied the tg3 has a NULL pointer dereference
> > > somewhere, but I can only see the first line of the oops, afterwards the box
> > > hangs solid.
> > 
> > That's a 5705, isn't it? So using the 'tso5' firmware?
> > 

Here is updated patch :-

http://git.infradead.org/users/jaswinder/firm-jsr-2.6.git?a=commitdiff;h=aa8b184d8eb4f1d7b5e37d5ad449fb7c02ad79c2

Original tg3 driver have 3 firmwares :-
1. static const u32 tg3FwText[(TG3_FW_TEXT_LEN / sizeof(u32)) + 1]
2. static const u32 tg3TsoFwText[(TG3_TSO_FW_TEXT_LEN / 4) + 1]
3. static const u32 tg3Tso5FwText[(TG3_TSO5_FW_TEXT_LEN / 4) + 1]

your hardware needs which of the above firmware.

> Unfortunately, it doesn't help.  The driver either oopses or just doesn't work
> (I don't know what exactly causes it to oops, although that only happens during
> boot).
> 

Please give us more info about oops.

You always get oops or sometimes.

If you want I can put some debugging message.

﻿> However, Ingo wrote that
> 
> " the firmware image, if i compare the before and after tg3FwText 
> hex dump is blatantly different. Is this some different format, or did 
> the "convert to request_firmware()" commit also embed an undocumented 
> version jump in the binary blob that is loaded to your card? "
> 
> May this be the source of the problem?
> 

No, firmware is same.

Our Firmware blob looks like this...
	u8 firmware_major
	u8 firmware_minor
	u8 firmware_fix
	u8 pad
	__be32 start_address
	__be32 length (total, including BSS sections to be zeroed)
	data... (in __be32 words, which is native for the firmware)

rest of data is same and you can see it manually.

I am surprise why Ingo is using hex dump and he finds different data.

And I did not received any feedback from Ingo yet.

Thank you,

Jaswinder Singh.

