Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYHBOit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYHBOit (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 10:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYHBOik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 10:38:40 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:45401 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752476AbYHBOii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 10:38:38 -0400
X-Sasl-enc: 9RG/BH+CHnowezVor76VCDKL6O2aJhOzYtaDaWkRR/QE 1217687917
Date: Sat, 2 Aug 2008 11:38:33 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Len Brown <lenb@kernel.org>, Thomas Renninger <trenn@suse.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>,
       Christian Kornacker <ckornacker@suse.de>
Subject: Re: ACPI OSI disaster on latest HP laptops - critical temperature
	shutdown
Message-ID: <20080802143833.GC14069@khazad-dum.debian.net>
References: <200807241727.41715.trenn@suse.de> <alpine.LFD.1.10.0807241952270.6098@localhost.localdomain> <200807251319.12786.trenn@suse.de> <alpine.LFD.1.10.0807250948320.3884@localhost.localdomain> <alpine.LFD.1.10.0808011706350.3011@localhost.localdomain> <20080801223657.GD23558@khazad-dum.debian.net> <20080802054204.GB12646@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802054204.GB12646@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 02 Aug 2008, Matthew Garrett wrote:
> On Fri, Aug 01, 2008 at 07:36:57PM -0300, Henrique de Moraes Holschuh wrote:
> > On Fri, 01 Aug 2008, Len Brown wrote:
> > > It is better to expose ourselves to the known tested Windows functionality
> > > -- even if it seems arbitrary, at least it is tested.  The !Windows case
> > > results in running _completely_ untested BIOS code.
> > 
> > Actually, we should masquerade properly as the latest Windows version
> > available for that machine, then.  AFAIK, Windows does not set ALL the OSI
> > strings, just one.  We ARE running untested code in some BIOSes because of
> > it.
> 
> The BIOSes I've tested check _OSI in order of Windows release, which is 
> consistent with Windows returning OSI strings for all previous versions. 
> Do you have any examples that suggest this isn't the case?

Yes.  IBM ThinkPads store the result of each version test separately, and I
recall I saw at least one DSDT code path that didn't test all of them in
order to select a branch of code to run.

It will be hard to find that DSDT, though. It was sometime ago :(

> > Maybe it would be better if every ACPICA-using OS defined a
> > _OSI(NotWindows), plus the relevant Windows OSI string they want to support,
> > and Intel would send word that this string is to be used ONLY to disable all
> > Windows bug workarounds, not to activate or deactivate any specific
> > functionality?
> 
> Not all BIOSes would support this, so we'd need to support the Windows 
> workarounds anyway. At that point, there's no real benefit in having 
> multiple codepaths.

Sorry, but I will disagree.

Anything that can help in the future with the vendors that are better at
Linux support is a good thing.  You are right that we will still have to
deal with the others, but there are such things as vendor-specific windows
workarounds (they didn't want to change their firmware, or they couldn't, or
the others didn't care to add the workaround, etc).  If that vendor uses the
"NotWindows" OSI correctly, we would not need to take any special action.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
