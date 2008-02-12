Return-Path: <linux-kernel-owner+w=401wt.eu-S1761964AbYBLLVJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761964AbYBLLVJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 06:21:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYBLLU4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 06:20:56 -0500
Received: from mx1.suse.de ([195.135.220.2]:60219 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754724AbYBLLUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 06:20:55 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [PATCH] [5/8] Fix logic error in 64bit memory hotadd
Date: Tue, 12 Feb 2008 12:20:51 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
References: <20080211124625.GB23733@elte.hu> <200802111405.04423.ak@suse.de> <20080212190310.F9E8.Y-GOTO@jp.fujitsu.com>
In-Reply-To: <20080212190310.F9E8.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802121220.51755.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 February 2008 11:35:22 Yasunori Goto wrote:
> Hi Ingo-san.
> 
> > > Does anyone even  
> > > use memory hotplug currently? 
> > 
> > I don't know.
> 
> IBM's powerpc box can memory hot-add/remove by dynamic partitioning.
> And our fujitsu server has memory hot-add feature (Ia-64).
> So, they are concrete user of memory hotplug.
> 
> In x86, E8500 chipset has the feature of memory-hotplug.
> (I searched a data-sheet from intel site.)
> http://download.intel.com/design/chipsets/e8500/datashts/30674501.pdf
> (6.3.8 IMI Hot-Plug)
> 
> So, it depends on how many server uses it, I think.

With the logic pud error i found and that seems currently will stay
for the forseeable future in the tree I don't think x86-64 64bit hotadds for more
than 1GB have ever worked with the sparsemem method.

Older trees (before 2.6.24) had also a different method that did
preallocate everything based on the SRAT. That one should have worked 
for this case.

-Andi
