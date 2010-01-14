Return-Path: <linux-kernel-owner+w=401wt.eu-S1755627Ab0ANKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755627Ab0ANKSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 05:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755200Ab0ANKSR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 05:18:17 -0500
Received: from one.firstfloor.org ([213.235.205.2]:51332 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab0ANKSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 05:18:16 -0500
To: Greg KH <gregkh@suse.de>
Cc: Tilman Schmidt <tilman@imap.cc>, Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       Karsten Keil <isdn@linux-pingi.de>, isdn4linux@listserv.isdn4linux.de
Subject: Re: Can we remove pci_find_device() yet?
From: Andi Kleen <andi@firstfloor.org>
References: <20100108112236.462a3da2.sfr@canb.auug.org.au>
	<20100108044646.GC6611@suse.de> <4B4B802A.2010709@imap.cc>
	<20100111200136.GA29955@suse.de>
Date: Thu, 14 Jan 2010 11:18:12 +0100
In-Reply-To: <20100111200136.GA29955@suse.de> (Greg KH's message of "Mon, 11 Jan 2010 12:01:36 -0800")
Message-ID: <877hrlf0rf.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:
>
> Close, but if you do this, please name the function
> hisax_find_pci_device() or something, and change the drivers to use it
> instead.  Also put a big fat warning in the function that calling this
> is unsafe for any PCI hotplug type machine.

It would be better to enforce this constraint at runtime.

e.g. set some global variable that forbids device removal
and warn in the kernel log. In theory this could be also
done per device, but I guess that would be more effort.

Of course it cannot prevent the user from really removing
a device, but at least the pci_dev could stay around.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
