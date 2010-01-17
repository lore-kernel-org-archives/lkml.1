Return-Path: <linux-kernel-owner+w=401wt.eu-S1754210Ab0AQReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab0AQReS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 12:34:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504Ab0AQReR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 12:34:17 -0500
Received: from outbound-mail-158.bluehost.com ([67.222.39.38]:48219 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753839Ab0AQReQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 12:34:16 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=FatocwWLAi5lYdA038Ou2K9Fr55sUIAi9S59b/eMqLg/b9c6gO6TlK61HsscfU1FM7DDIpCjzdr2GiZy0eeHiPDiSFQJR55ra1wyDpFD4fyvEVSURCzB0ZGSwGM7EpTi;
Date: Sun, 17 Jan 2010 09:34:18 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Alex Chiang <achiang@hp.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 10/11] pciehp: add support for bridge resource
 reallocation
Message-ID: <20100117093418.6d545b43@jbarnes-piketon>
In-Reply-To: <1263683671.29907.47.camel@dc7800.home>
References: <1263609721-3921-1-git-send-email-yinghai@kernel.org>
	<1263609721-3921-11-git-send-email-yinghai@kernel.org>
	<20100116045911.GI22215@ldl.fc.hp.com>
	<4B518815.70006@kernel.org>
	<1263683671.29907.47.camel@dc7800.home>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jan 2010 16:14:31 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> On Sat, 2010-01-16 at 01:34 -0800, Yinghai Lu wrote:
> > On 01/15/2010 08:59 PM, Alex Chiang wrote:
> > > * Yinghai Lu <yinghai@kernel.org>:
> > >> From: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> > >>
> > >> With this patch, pciehp driver try to clear PCI bridge resources
> > >> to parent bridge (root port or switch downstream port) of the
> > >> slot
> > >>
> > >> so we can shrink pci bridge resource for those port
> > >>
> > >> This feature is enabled when 'pciehp_realloc' option is
> > >> specified.
> > >>
> > >> -v2: make it could be appiled after Yinghai patchset that touch
> > >> pci bridge resource also remove poweron check, because
> > >> pci_bridge_release_res will check child at first
> > > 
> > > Same comment as my earlier patch. Why not just make this the
> > > default behavior, instead of introducing yet another command line
> > > parameter for users to guess at?
> > 
> > it will break Eric's setup/
> 
> I think this is a clue that we don't understand the problem well
> enough yet.
> 
> I'm opposed to adding kernel parameters for this sort of thing.  It is
> unreasonable to expect users to figure out whether they need to use
> this parameter or not.
> 
> Special-case switches like this make it much harder to maintain the
> code in the future.

Agreed.  Yinghai, what's wrong in the new reassignment code that
causes Eric's setup to break?  Can we just fix that instead and enable
reallocation by default?

-- 
Jesse Barnes, Intel Open Source Technology Center
