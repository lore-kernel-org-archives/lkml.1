Return-Path: <linux-kernel-owner+w=401wt.eu-S1756177AbZFCUWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbZFCUWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZFCUWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:22:38 -0400
Received: from www.tglx.de ([62.245.132.106]:45438 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZFCUWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:22:37 -0400
Date: Wed, 3 Jun 2009 22:20:02 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Bill Davidsen <davidsen@tmr.com>
cc: George Dunlap <george.dunlap@eu.citrix.com>,
       David Miller <davem@davemloft.net>, "jeremy@goop.org" <jeremy@goop.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       "avi@redhat.com" <avi@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Keir Fraser <Keir.Fraser@eu.citrix.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "gregkh@suse.de" <gregkh@suse.de>,
       "kurt.hackel@oracle.com" <kurt.hackel@oracle.com>,
       Ian Pratt <Ian.Pratt@eu.citrix.com>,
       "xen-users@lists.xensource.com" <xen-users@lists.xensource.com>,
       ksrinivasan <ksrinivasan@novell.com>,
       "EAnderson@novell.com" <EAnderson@novell.com>,
       "wimcoekaerts@wimmekes.net" <wimcoekaerts@wimmekes.net>,
       Stephen Spector <stephen.spector@citrix.com>, jens.axboe@oracle.com
Subject: Re: Xen is a feature
In-Reply-To: <4A26D3D8.6080002@tmr.com>
Message-ID: <alpine.LFD.2.00.0906032204220.3419@localhost.localdomain>
References: <162f4c90-6431-4a2a-b337-6d7451d7b11e@default> <20090528001350.GD26820@elte.hu> <4A1F302E.8030501@goop.org> <20090528.210559.137121893.davem@davemloft.net> <4A1FCE8E.2060604@eu.citrix.com> <alpine.LFD.2.00.0905311607560.3379@localhost.localdomain>
 <4A26D3D8.6080002@tmr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Jun 2009, Bill Davidsen wrote:
> Thomas Gleixner wrote:
> > Aside of the paravirt, which seems to expand through arch/x86 like a
> > hydra, the new patches sprinkle "if (xen_...)" all over the
> > place. These extra xen dependencies are no improvement, they are a
> > royal pain in the ... They are sticky once they got merged simply
> > because the hypervisor relies on them and we need to provide
> > compatibility for a long time.
> > 
> Wait, let's not classify something as "no improvement" when you mean "I don't
> need it."

It's not about "I don't need it.". It's about having Xen dependencies
in the code all over the place which make mainatainence harder. I have
to balance the users benefit (xen dom0 support) vs. the impact on
maintainability and the restrictions which are going to be set almost
in stone by merging it.

> Let's stick to technical issues, and not deny that there are a number of users
> who really will have expanded capability. The technical points are valid, but
> as a former and probable future xen (CentOS) user, so are the benefits.

Refusing random "if (xen...)" dependencies is a purely technical
decision. I have said more than once that I'm not against merging dom0
in general, I'm just frightened by the technical impact of a defacto
ABI which we swallow with it.

We have enough problems with real silicon and BIOS/ACPI already, why
should we add artifical and _avoidable_ virtual silicon horror ?

Thanks,

	tglx
