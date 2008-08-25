Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYHYBhz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYHYBhz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 21:37:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYHYBhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 21:37:45 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:27205 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbYHYBho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 21:37:44 -0400
X-IronPort-AV: E=Sophos;i="4.32,264,1217808000"; 
   d="scan'208";a="145586373"
From: Roland Dreier <rdreier@cisco.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>,
       linux-usb <linux-usb@vger.kernel.org>, torvalds@linux-foundation.org
Subject: Re: [patch] Add helper macros for little-endian bitfields
References: <48AD6AF0.3050504@csr.com> <48AD6B93.7020702@csr.com>
X-Message-Flag: Warning: May contain useful information
Date: Sun, 24 Aug 2008 18:37:43 -0700
In-Reply-To: <48AD6B93.7020702@csr.com> (David Vrabel's message of "Thu, 21
	Aug 2008 14:20:19 +0100")
Message-ID: <adaprnxnac8.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 25 Aug 2008 01:37:43.0826 (UTC) FILETIME=[2B7A5720:01C90653]
Authentication-Results: sj-dkim-3; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim3002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > + * NOTE: When using multibyte bitfields, you need to convert the data
 > + *       from Little Endian to CPU before you can access the bitfield
 > + *       (to make it simpler):
 > + *
 > + *       union something {
 > + *               le16 value;
 > + *               DECL_BF_LE3(
 > + *                       u16  bf0:3,
 > + *                       u16  bf1:10,
 > + *                       u16  bf2:3
 > + *               ) __attribute__((packed));
 > + *       };
 > + *
 > + *       ...
 > + *
 > + *       union something s;
 > + *
 > + *       s.value = le16_to_cpu(something LE read from hw);
 > + *       frame_count = s.bf1;

I can't help thinking there's got to be a better way to do this... in
particular having 16 DECL_BF_LEnn() macros (and needing to count the
number of members every time you use one) is not particularly pretty.

In general the consensus with kernel code seems to be that you're better
off avoiding bitfields in structures, and just using shift/mask
operations to get at the data (with helper functions as needed).

However all of that is said without actually looking at the driver code
that uses this.

 - R.
