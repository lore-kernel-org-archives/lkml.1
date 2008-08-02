Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbYHBPlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbYHBPlc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbYHBPlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:41:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36634 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYHBPlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:41:23 -0400
Date: Sat, 2 Aug 2008 16:41:14 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature shutdown
Message-ID: <20080802154114.GA28879@srcf.ucam.org>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org> <20080802143833.GC14069@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802143833.GC14069@khazad-dum.debian.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 11:38:33AM -0300, Henrique de Moraes Holschuh wrote:

> Yes.  IBM ThinkPads store the result of each version test separately, and I
> recall I saw at least one DSDT code path that didn't test all of them in
> order to select a branch of code to run.

As an example, here's a section from the T61:

                    If (\_OSI ("Windows 2001"))
                    {
                        Store (0x01, \WNTF)
                        Store (0x01, \WXPF)
                        Store (0x00, \WSPV)
                    }

                    If (\_OSI ("Windows 2001 SP1"))
                    {
                        Store (0x01, \WSPV)
                    }

                    If (\_OSI ("Windows 2001 SP2"))
                    {
                        Store (0x02, \WSPV)
                    }

And then later:

           If (LAnd (\WXPF, LGreaterEqual (\WSPV, 0x01)))
            {
                PPMS (0x02)
            }

The only way WXPF can be non-zero and WSPV can be greater or equal to 
one is if more than one of those tests succeeded.

> > Not all BIOSes would support this, so we'd need to support the Windows 
> > workarounds anyway. At that point, there's no real benefit in having 
> > multiple codepaths.
> 
> Sorry, but I will disagree.
> 
> Anything that can help in the future with the vendors that are better at
> Linux support is a good thing.  You are right that we will still have to
> deal with the others, but there are such things as vendor-specific windows
> workarounds (they didn't want to change their firmware, or they couldn't, or
> the others didn't care to add the workaround, etc).  If that vendor uses the
> "NotWindows" OSI correctly, we would not need to take any special action.

Allowing vendors to special-case Linux means that we have to have a 
special-case path for the minority of vendors who ask for this. It's 
added complexity and we don't actually gain anything from it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
