Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbYIFSp4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbYIFSp4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 14:45:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbYIFSpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 14:45:47 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62694 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYIFSpq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 14:45:46 -0400
Date: Sat, 6 Sep 2008 19:45:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, yhlu.kernel@gmail.com
Subject: Re: [patch 3/3] x86: io-apic - code style cleaning for setup_IO_APIC_irqs
In-Reply-To: <20080906101533.GA7273@lenovo>
Message-ID: <Pine.LNX.4.55.0809061938250.13851@cliff.in.clinika.pl>
References: <20080904183748.950151853@gmail.com>> <48c02b6a.0637560a.15e9.ffffa39d@mx.google.com>
 <20080905080447.GC12409@elte.hu> <20080905180126.GA19334@lenovo>
 <20080905181111.GG27395@elte.hu> <20080905183347.GB19334@lenovo>
 <20080905183835.GA19215@elte.hu> <20080906101533.GA7273@lenovo>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Sep 2008, Cyrill Gorcunov wrote:

> Ingo, how about the following approach? We don't introduce new
> functions but rather srink the code by new printout form.

 Honestly, this one should probably use sprintf() or suchlike to avoid the
mess of printk() calls building a line of output from pieces.  It's quite
easy to calculate here what the maximum size of the buffer required could
be and automatic arrays can have variable size, so no need for the hassle
of heap management.  Calls to printk() without a trailing newline should
be avoided where possible as it messes up logging priority if a message
pops up from an interrupt inbetween.

  Maciej
