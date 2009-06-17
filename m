Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbZFQETZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbZFQETZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 00:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750886AbZFQETP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 00:19:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60680 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbZFQETO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 00:19:14 -0400
Date: Tue, 16 Jun 2009 21:19:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Patterson <andrew.patterson@hp.com>
cc: linux-pci@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       jbarnes@virtuousgeek.org, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: [PATCH 0/1] Recurse when searching for empty slots in resources
 trees
In-Reply-To: <1245208744.19708.243.camel@grinch>
Message-ID: <alpine.LFD.2.01.0906162116280.16802@localhost.localdomain>
References: <20090616220419.14021.84524.stgit@bob.kio>  <alpine.LFD.2.01.0906161511390.16802@localhost.localdomain>  <1245192703.8234.226.camel@bluto.andrew>  <alpine.LFD.2.01.0906161556020.16802@localhost.localdomain>  <1245195498.8234.236.camel@bluto.andrew>
  <alpine.LFD.2.01.0906161640250.16802@localhost.localdomain>  <alpine.LFD.2.01.0906161717220.16802@localhost.localdomain>  <alpine.LFD.2.01.0906161804030.16802@localhost.localdomain> <1245208744.19708.243.camel@grinch>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Jun 2009, Andrew Patterson wrote:
> 
> This looks functionally equivalent to the current code.

Absolutely. It's only meant to add the call chains for all the resource 
additions, so that we could see how that buggy 'c2' resource gets added as 
a parent to 'c3' (when it should be the other way around).

> I get way too much output to be useful.  I can log the serial port if we 
> need it all, or I can change it to just look at the buses in question if 
> desired.

Sure. Or increase CONFIG_LOG_BUF_SHIFT to 22 or somethng insane like that 
(so that it logs up to 4MB of messages).

But yeah, if you just make it smarter, and only do that WARN() thing for 
resources that match "PCI Bus" at the beginning of the name, that should 
be plenty good enough.

			Linus
