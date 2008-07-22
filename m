Return-Path: <linux-kernel-owner+w=401wt.eu-S1754537AbYGVQww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbYGVQww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 12:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYGVQwo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 12:52:44 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54665 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187AbYGVQwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 12:52:43 -0400
Date: Tue, 22 Jul 2008 10:52:41 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Eran Liberty <liberty@extricom.com>
Cc: eran liberty <eran.liberty@gmail.com>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH 2.6.26] PCI: refuse to re-add a device to a bus upon pci_scan_child_bus()
Message-ID: <20080722165241.GD7337@parisc-linux.org>
References: <48591941.4070408@extricom.com> <4884E0FB.9010909@extricom.com> <20080721194957.GH24246@parisc-linux.org> <ffc2b1d40807220121r44823a89jf0126bc1f5273443@mail.gmail.com> <20080722114929.GA7337@parisc-linux.org> <4885DD41.9010202@extricom.com> <20080722141327.GB7337@parisc-linux.org> <4885FBF4.6070306@extricom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4885FBF4.6070306@extricom.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 06:25:40PM +0300, Eran Liberty wrote:
> If my devices where the only one on the bus I would not have stumbled on 
> this bug. I would have removed them all before reloading and would have 
> scanned and empty PCI bus list after the reloading.

That's not true, the code you posted:

bus = null;
while ((bus = pci_find_next_bus(bus)) != NULL) {
        pci_scan_child_bus(bus);
        pci_bus_assign_resources(bus);
        pci_bus_add_devices(bus);
}

will scan all busses again.

> Alas, the CPU itself is a pci device. Upon scanning the bus it is it who 
> is duplicated. Upon trying to "pci_bus_add_devices()" you get resource 
> collision.

Does the CPU have BARs of its own?  If you have no other devices with
BARs, it would explain why you have not noticed the problem with
fixup_resource ;-)

> Do you perceive any down side to my suggested patch?
> It seems (to me) really logical that a device can not and should not be 
> added twice to a pci bus device list.

The problem is the other side-effects of what you propose.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
