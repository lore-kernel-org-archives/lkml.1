Return-Path: <linux-kernel-owner+w=401wt.eu-S1751410Ab0APXUJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410Ab0APXUJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jan 2010 18:20:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056Ab0APXUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 18:20:08 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:29301 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab0APXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 18:20:07 -0500
Subject: Re: [PATCH 10/11] pciehp: add support for bridge
	resource	reallocation
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Alex Chiang <achiang@hp.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <4B518815.70006@kernel.org>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
	 <1263609721-3921-11-git-send-email-yinghai@kernel.org>
	 <20100116045911.GI22215@ldl.fc.hp.com>  <4B518815.70006@kernel.org>
Content-Type: text/plain
Date: Sat, 16 Jan 2010 16:14:31 -0700
Message-Id: <1263683671.29907.47.camel@dc7800.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-01-16 at 01:34 -0800, Yinghai Lu wrote:
> On 01/15/2010 08:59 PM, Alex Chiang wrote:
> > * Yinghai Lu <yinghai@kernel.org>:
> >> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> >>
> >> With this patch, pciehp driver try to clear PCI bridge resources to
> >> parent bridge (root port or switch downstream port) of the slot
> >>
> >> so we can shrink pci bridge resource for those port
> >>
> >> This feature is enabled when 'pciehp_realloc' option is specified.
> >>
> >> -v2: make it could be appiled after Yinghai patchset that touch pci bridge
> >>      resource also remove poweron check, because pci_bridge_release_res will
> >>      check child at first
> > 
> > Same comment as my earlier patch. Why not just make this the
> > default behavior, instead of introducing yet another command line
> > parameter for users to guess at?
> 
> it will break Eric's setup/

I think this is a clue that we don't understand the problem well enough
yet.

I'm opposed to adding kernel parameters for this sort of thing.  It is
unreasonable to expect users to figure out whether they need to use this
parameter or not.

Special-case switches like this make it much harder to maintain the code
in the future.

Bjorn


