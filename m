Return-Path: <linux-kernel-owner+w=401wt.eu-S1752950AbYIBAKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752950AbYIBAKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751677AbYIBAKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:10:42 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54486 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbYIBAKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:10:41 -0400
Date: Mon, 1 Sep 2008 18:10:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>, "Zhao, Yu" <yu.zhao@intel.com>,
       jbarnes@virtuousgeek.org, Greg KH <gregkh@suse.de>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI Hotplug: fakephp: fix deadlock... again
Message-ID: <20080902000951.GM1239@parisc-linux.org>
References: <20080821201918.GA24411@ldl.fc.hp.com> <20080821202504.GU8318@parisc-linux.org> <20080821204758.GB31543@suse.de> <20080821221438.GC20014@ldl.fc.hp.com> <7A25B56E4BE99C4283EB931CD1A40E110177E488@pdsmsx414.ccr.corp.intel.com> <20080830053755.GA16219@suse.de> <7A25B56E4BE99C4283EB931CD1A40E110177E490@pdsmsx414.ccr.corp.intel.com> <7A25B56E4BE99C4283EB931CD1A40E110177E4DA@pdsmsx414.ccr.corp.intel.com> <20080901184018.GA14492@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080901184018.GA14492@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 12:40:18PM -0600, Alex Chiang wrote:
> We get the "slot already scheduled for removal" because that
> particular device has 2 functions, and we're creating slots on a
> per-slot basis now, not a per-function basis.
> 
> Although, I wonder, Willy -- is that really the right thing to
> do? Seems like fakephp would be more useful if we did operate on
> a per-function basis, and not per-slot. Especially given Yu's
> work with SR-IOV, where we can apparently have lots of functions
> per a physical device.

I suspect it depends on what you believe the point of fakephp is.
My assumption was that it was a way to fake what would happen if you had
a hotplug controller for a particular slot.  In that context, the change
I made was clearly correct.  If you want to use it for hot-removing
individual functions from a Linux guest running under a hypervisor
(for example), that's much less useful.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
