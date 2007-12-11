Return-Path: <linux-kernel-owner+w=401wt.eu-S1755037AbXLKRgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbXLKRgR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:36:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbXLKRgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:36:04 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:58442 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbXLKRgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:36:03 -0500
Date: Tue, 11 Dec 2007 18:37:17 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       kvm-devel <kvm-devel@lists.sourceforge.net>
Subject: Re: [RFC] Proposed new directory layout for kvm and virtualization
Message-ID: <20071211173717.GA26368@uranus.ravnborg.org>
References: <475E5CBB.9080608@qumranet.com> <20071211161032.GA25769@uranus.ravnborg.org> <475EB7AC.9040903@qumranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475EB7AC.9040903@qumranet.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11, 2007 at 06:15:40PM +0200, Avi Kivity wrote:
> Sam Ravnborg wrote:
> >On Tue, Dec 11, 2007 at 11:47:39AM +0200, Avi Kivity wrote:
> >  
> >>KVM is due to receive support for multiple architectures (ppc, ia64, and 
> >>s390, in addition to the existing x86), hopefully in time for the 2.6.25 
> >>merge window.  It is awkward to place the new arch support in 
> >>drivers/kvm/, so I'd like to propose the following new layout:
> >>
> >> virt/         top-level directory for hypervisors
> >> virt/kvm/     kvm common code
> >> virt/lguest/  the other hypervisor
> >> arch/*/kvm/   arch dependent kvm code
> >>    
> >
> >The arch/*/dir shall use same dir-name as used
> >in top-level directory.
> >  
> 
> Well, it isn't like that now (arch/x86/oprofile, etc.)
oprofile is now the best leader to follow in this respect.
Just look at the utterly crap in their makefiles.

> >So use arch/*/virt/kvm/ if kvm really requires
> >a subdirectory of it own. Preferably not.
> >A handful of files named kvm* does not warrant their own
> >subdirectory IMO.
> >
> >  
> 
> We'll have 5-6 x86 specific files.
> 
> Where do you suggest we place them?
/arch/x86/virt/

Seems logical and fit the way we handle mm/ versus arch/*/mm,
kernel/ arch/*/kernel etc.

Are there any dependencies between the arch and non-arch files
such as they are combined in a single module?

	Sam
