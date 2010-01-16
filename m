Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab0APEiw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 23:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755134Ab0APEiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 23:38:50 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:42866 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab0APEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 23:38:49 -0500
Date: Fri, 15 Jan 2010 21:38:47 -0700
From: Alex Chiang <achiang@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/11] pci: update bridge res to get more big range in
	pci assign unssign
Message-ID: <20100116043847.GE22215@ldl.fc.hp.com>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org> <1263609721-3921-6-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263609721-3921-6-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Yinghai Lu <yinghai@kernel.org>:
> BIOS separate IO range between several IOHs, and on some slots,
> BIOS assign the resource to the bridge, but stop assigning
> resource to the device under that bridge, because the device
> need big resource.
> 
> 1. pci assign unassign and record the failed device resource.
> 2. clear the BIOS assigned resource of the parent bridge of fail device
> 3. go back and call pci assign unsigned
> 4. if it still fail, will go up more bridges. and clear and try again.

I agree with Jesse and Bjorn. I really hate introducing a new
command line param.

The goal here should be to do the right thing, all the time,
without requiring command line parameters.

I understand that you are avoiding a change to existing behavior
by defaulting to try=1.

What I don't understand is how you expect your change to benefit
any actual users. The usage model you propose is:

	- user encounters failure

	- user emails lkml/linux-pci and says "why doesn't my
	  device get resources?"

	- we tell user, "please reboot with try=N for increasing
	  values of N until it works"

Why shouldn't we be aggressive all the time?

If this patch series is going to be accepted, we should turn it
on all the time. Everyone will get the benefits.

If it breaks machines, depending on the bug reports, it will end
up either:

	a) we missed an implementation detail (easily fixed)

	or 

	b) the design/strategy is wrong, in which case we need to
	take a step back and think about a different approach to
	solve the problem you're trying to solve

For this patch, I don't mind the changes to
pci_assign_unassigned_resources(), but I really do not agree with
the configurability introduced in pci_setup().

thanks,
/ac
