Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbYKRFk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbYKRFk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 00:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750752AbYKRFkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 00:40:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55101
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750741AbYKRFkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 00:40:18 -0500
Date: Mon, 17 Nov 2008 21:40:18 -0800 (PST)
Message-Id: <20081117.214018.238557661.davem@davemloft.net>
To: paulus@samba.org
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tglx@linutronix.de, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: Large stack usage in fs code (especially for PPC64)
From: David Miller <davem@davemloft.net>
In-Reply-To: <18722.10784.719186.434130@cargo.ozlabs.ibm.com>
References: <alpine.DEB.1.10.0811171557370.26123@gandalf.stny.rr.com>
	<alpine.DEB.1.10.0811172128380.26123@gandalf.stny.rr.com>
	<18722.10784.719186.434130@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Tue, 18 Nov 2008 13:36:16 +1100

> Steven Rostedt writes:
> 
> > By-the-way, my box has been running stable ever since I switched to 
> > CONFIG_IRQSTACKS.
> 
> Great.  We probably should remove the config option and just always
> use irq stacks.

That's what I did from the start on sparc64 when I added
irqstacks support.  It's pretty stupid to make it optional
when we know there are failure cases.

For example, is XFS dependant on IRQSTACKS on x86?  It should be, or
even more so XFS and NFS both being enabled at the same time :-)
