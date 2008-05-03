Return-Path: <linux-kernel-owner+w=401wt.eu-S1763121AbYECKEG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763121AbYECKEG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 06:04:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759722AbYECKD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 06:03:56 -0400
Received: from www.tglx.de ([62.245.132.106]:38225 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936AbYECKDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 06:03:55 -0400
Date: Sat, 3 May 2008 12:02:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: Adrian Bunk <bunk@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org
Subject: Re: x86 git acpi issue?
In-Reply-To: <20080503094551.GA10805@elte.hu>
Message-ID: <alpine.LFD.1.10.0805031201130.6003@apollo.tec.linutronix.de>
References: <481BAC6F.5090509@ct.jp.nec.com> <481BACEC.8080902@zytor.com> <20080503071332.GF5838@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0805031123420.6003@apollo.tec.linutronix.de> <20080503094551.GA10805@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Ingo Molnar wrote:
> > Right. This Makefile is a nasty trap. I looked into it and the fix for 
> > now is below. Long term this Makefile trickery needs to be cleaned up 
> > to avoid trapping into this again.
> 
> Thanks Thomas, i messed up that commit - i should have known that the 
> NUMAQ build fix looked _too_ easy ;-)

Also the move of 
pci-$(CONFIG_ACPI)             += acpi.o
is what broke things.

There is a nasty init function ordering problem as well between

pci-$(CONFIG_ACPI)             += acpi.o
pci-y                          += legacy.o irq.o

Sigh.

	tglx
