Return-Path: <linux-kernel-owner+w=401wt.eu-S942047AbXHMVhK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942047AbXHMVhK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 17:37:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758344AbXHMVgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 17:36:47 -0400
Received: from atlrel9.hp.com ([156.153.255.214]:56977 "EHLO atlrel9.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbXHMVgo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 17:36:44 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Michael Mauch <michael.mauch@gmx.de>
Subject: Re: Serial ports rearranged in 2.6.22?
Date: Mon, 13 Aug 2007 15:34:14 -0600
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <20070810213925.GB10855@elmicha> <86802c440708102154r59e1acbj90fa0d5b73197fb9@mail.gmail.com> <20070811154925.GA9618@elmicha>
In-Reply-To: <20070811154925.GA9618@elmicha>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708131534.15235.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 11 August 2007 09:49:25 am Michael Mauch wrote:
> Yinghai Lu wrote:
> 
> > On 8/10/07, Michael Mauch <michael.mauch@gmx.de> wrote:
> > > until 2.6.21, I had the normal assignments for ttyS0 and ttyS1:
> > >
> > > 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> > > 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> > >
> > > With 2.6.22 I get the names <-> ports/irqs the other way around:
> > >
> > > 00:08: ttyS0 at I/O 0x2f8 (irq = 3) is a 16550A
> > > 00:09: ttyS1 at I/O 0x3f8 (irq = 4) is a 16550A
> > > ...
> > http://lkml.org/lkml/2007/7/25/455
> 
> Thanks - I applied that patch and the names are back to normal again:
> 
> 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> 00:07: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

Just FYI, the patch Yinghai mentioned above was experimental, and
we decided it was the wrong solution.

For 2.6.22, the easiest workaround is to boot with the 
"legacy_serial.force" option.

For 2.6.23, we reverted my patch that caused the names to be swapped:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=57d4810ea0d9ca58a7bcc1336607f0cede0a2abf

Bjorn
