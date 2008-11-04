Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYKDSPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYKDSPe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:15:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753392AbYKDSPT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:15:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbYKDSPS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:15:18 -0500
Message-ID: <491090F3.5020701@zytor.com>
Date: Tue, 04 Nov 2008 10:14:11 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@fastmail.fm>
CC: Andi Kleen <andi@firstfloor.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, lguest@ozlabs.org,
       jeremy@xensource.com, Steven Rostedt <srostedt@redhat.com>,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
References: <20081104122839.GA22864@mailshack.com>  <20081104150729.GC21470@localhost>  <20081104170501.GE29626@one.firstfloor.org> <1225822006.21441.1282961299@webmail.messagingengine.com>
In-Reply-To: <1225822006.21441.1282961299@webmail.messagingengine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> 
> That's good to know. I assume this LOCKed bus cycle only occurs
> if the (hidden) segment information is not cached in some way?
> How many segments are typically cached? In particular, does it
> optimize switching between two segments?
> 

Yes, there is a segment descriptor cache (as opposed to the hidden but
architectural segment descriptor *registers*, which the Intel
documentation confusingly call a "cache".)

It is used to optimize switching between a small number of segments, and
was crucial for decent performance on Win9x, which contained a bunch of
16-bit code.

	-hpa
