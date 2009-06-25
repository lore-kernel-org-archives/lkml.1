Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZFYAAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZFYAAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 20:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbZFYAAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 20:00:08 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57596 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZFYAAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 20:00:07 -0400
Date: Wed, 24 Jun 2009 17:00:05 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinder@kernel.org>
Subject: Re: [PATCH] x86/pci: don't use crs for root if we only have one
	root bus
Message-ID: <20090625000005.GD12934@us.ibm.com>
References: <20090624122433.GA24781@elte.hu> <20090624145119.GA12664@elte.hu> <4A429EBB.5010209@kernel.org> <4A42AFAC.6000300@kernel.org> <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.01.0906241607100.18460@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 04:09:36PM -0700, Linus Torvalds wrote:
> 
> Should we not just revert 9e9f46c44e487af0a82eb61b624553e2f7118f5b?
> 
> The thing says:
> 
>  "At this point, it seems to solve more problems than it causes, so let's 
>   try using it by default.  It's an easy revert if it ends up causing 
>   trouble."
> 
> and it clearly does _not_ solve more problems than it causes, and the 
> whole message in that commit implies we should revert it.
> 
> I'm happy to apply various patches to fix it up, but regardless, I thinkwe 
> should revert that commit as bogus. We can try making it the default again 
> next round, when maybe it will be true that it doesn't cause issues.
> 
> What did it even ever help with?

In our case it is needed on some of our systems for PCI hotplug to
avoid MCKs due to a device under one root bus getting a resource
during hotplug that can only be used by devices under a different
root bus.  If the user does not intend to use PCI hotplug, the
function isn't needed (i.e. 'pci=use_crs' can be omitted) because
resources are properly directed to the installed cards via BIOS
pre-assignment.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

