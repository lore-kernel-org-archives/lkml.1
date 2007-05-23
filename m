Return-Path: <linux-kernel-owner+w=401wt.eu-S1758593AbXEWXPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758593AbXEWXPX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 19:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756108AbXEWXPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 19:15:11 -0400
Received: from main.gmane.org ([80.91.229.2]:53607 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755709AbXEWXPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 19:15:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [RFC PATCH] PCI MMCONFIG: add validation against ACPI
 motherboard resources
Date: Wed, 23 May 2007 16:07:15 -0700
Organization: Linux Foundation
Message-ID: <20070523160715.566635eb@freepuppy>
References: <4635510D.4060103@shaw.ca>
	<200705231349.56976.jbarnes@virtuousgeek.org>
	<alpine.LFD.0.98.0705231352450.3890@woody.linux-foundation.org>
	<200705231403.24439.jbarnes@virtuousgeek.org>
	<4654AD91.1030808@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: 069-064-229-129.pdx.net
In-Reply-To: <4654AD91.1030808@pobox.com>
X-Newsreader: Sylpheed-Claws 2.6.0 (GTK+ 2.10.11; x86_64-pc-linux-gnu)
X-Face: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2007 17:09:37 -0400
Jeff Garzik <jgarzik@pobox.com> wrote:

> Jesse Barnes wrote:
> > Apparently Vista will move away from using type 1 config space accesses 
> > though, so if we keep using it, we'll probably run into some lame board 
> 
> Yep.
> 
> 
> > that assumes you're using mmconfig at some point in the near future.  
> > But then again, we're often on that less tested path (e.g. with ACPI), 
> > so maybe that doesn't matter much.
> 
> One of the reasons why hardware vendors want to move away from 
> traditional accesses is to be able to use the larger config space in 
> PCI-Express, rather than being locked into the 256-byte legacy PCI 
> config space.
> 
> Several modern PCI-Express devices utilize the upper config space, but 
> due to legacy reasons the registers are usually ones that do not require 
> OS drivers to know about (like BIST stuff or diagnostic registers).
> 
> Expect that to change, as MS shakes out the bugs (or maybe we are doing 
> their job for them?).
> 

On some PCI-Express boards, if you don't clear the advanced error reporting
registers on boot up, they will cause IRQ storm. The AER registers
are above 256 boundary. In fact, the AER support in Linux should depend
on MMCONFIG.

-- 
Stephen Hemminger <shemminger@linux-foundation.org>

