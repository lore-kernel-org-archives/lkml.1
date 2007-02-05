Return-Path: <linux-kernel-owner+w=401wt.eu-S1752661AbXBEGOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbXBEGOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 01:14:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbXBEGOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 01:14:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:43462 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752661AbXBEGOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 01:14:22 -0500
Subject: Re: [ANN] Userspace M-on-N threading model implementation. Alpha
	release.
From: Arjan van de Ven <arjan@infradead.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <45C65353.5000602@tmr.com>
References: <66910A579C9312469A7DF9ADB54A8B7D5C2B90@exchange.ZeugmaSystems.local>
	 <45C362D2.2040407@tmr.com>
	 <1170516376.3073.1015.camel@laptopd505.fenrus.org>
	 <45C63E30.4010106@tmr.com>
	 <20070204202053.GC20307@devserv.devel.redhat.com>
	 <45C65353.5000602@tmr.com>
Content-Type: text/plain
Organization: Intel International BV
Date: Mon, 05 Feb 2007 07:14:18 +0100
Message-Id: <1170656058.3073.1230.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-2.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> > On the other side, the overhead you need to add for every single syscall
> > that might block for the M:N threads and the associated complications
> > which make it far harder to conform to POSIX IMHO far outweight the costs
> > of going into the kernel for a context switch.
> 
> That really wasn't my question, Arjan said that switching real threads 
> wasn't a context switch in the hardware sense, and I was asking if I 
> missed something.

a hardware context switch is basically a CR3 change with associated tlb
flush. That is the part that is the most expensive of a context switch.
Just going into the kernel and getting out with a different EIP/ESP is
really cheap, in the order of "a few hundred cycles"; not a heck of a
lot more expensive than a simple getpid or other simple system call.


>  It may be cheap, but it would seem to be a context 
> switch none-the-less.

it includes a privilege level switch, not so much a full context
switch...

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

