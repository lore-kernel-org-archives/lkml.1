Return-Path: <linux-kernel-owner+w=401wt.eu-S1751225AbXEXORS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751225AbXEXORS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 10:17:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750712AbXEXORI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 10:17:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:46641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711AbXEXORG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 10:17:06 -0400
Subject: Re: 2.6.22-rc1-mm1 Implementing fan/thermal control in userspace -
	Was: [cannot change thermal trip points]
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070522003153.GA18162@srcf.ucam.org>
References: <200705171517.14087.lenb@kernel.org>
	 <1179604609.16465.83.camel@sublime.suse.de>
	 <200705202350.45145.lenb@kernel.org> <20070521121048.GA8332@elf.ucw.cz>
	 <20070521132711.GA7540@srcf.ucam.org> <20070521132948.GD8332@elf.ucw.cz>
	 <20070521133608.GB7540@srcf.ucam.org> <20070521134046.GE8332@elf.ucw.cz>
	 <20070521134553.GA7911@srcf.ucam.org> <20070521224200.GF10714@elf.ucw.cz>
	 <20070522003153.GA18162@srcf.ucam.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Thu, 24 May 2007 16:16:53 +0200
Message-Id: <1180016213.16396.74.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stripping some CCs, acpi and kernel list should be enough this one goes
to...

On Tue, 2007-05-22 at 01:31 +0100, Matthew Garrett wrote:
> On Tue, May 22, 2007 at 12:42:00AM +0200, Pavel Machek wrote:
> > On Mon 2007-05-21 14:45:53, Matthew Garrett wrote:
> > > So don't do it badly. The advantage of doing so is that you can make it 
> > > work properly, which you can't by putting it in the kernel.
> > 
> > You want stuff like critical shutdowns to work even if userspace is
> > dead.
> 
> I don't think anyone suggested putting the critical shutdown control in 
> userspace. The kernel already handles that fine.
> 
> > I do not think you can control passive cooling adequately from 
> > userspace, and you can certainly not prevent kernel from slowing 
> > machine down too soon.
> 
> Given the choice between something impossible and something difficult, 
> I'm inclined towards picking the difficult one.

I doubt it is impossible, would you mind sharing your knowledge why you
think it is impossible or point to some related discussion, pls.

Does this mean checking temperature against trip points and adjust fan
and cpufreq should be done in a hal module?
In which stage is this, rfc, development, already in some git tree?

Yes, trip points are overridden by BIOS on HPs and what is the problem?
The workaround won't work for them, but it still does on others
(mainly on ThinkPads which have passive tp at about 89 C and critical on
91 C).

I could imagine an implementation for this, that e.g. critical...active9
get module parameters. BIOS updates for trip points get ignored as soon
as one is set and you can only decrease a value. Nothing bad can happen
and it will make some people happy (yes it's hacky, violates the specs
and so on..., but some more people have a working machine). Will this
(or similar) get accepted?

It's even more impossible to get ACPI working correctly for all machines
and all subsystems, these little workarounds can help some people to at
least use their machine or get some parts working better.

   Thomas

