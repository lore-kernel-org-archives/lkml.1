Return-Path: <linux-kernel-owner+w=401wt.eu-S1754770AbYGXWHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbYGXWHZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 18:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbYGXWHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 18:07:13 -0400
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:46129 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751865AbYGXWHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 18:07:12 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=brHpkpgUv4uDhDDVFSJqNwcpr1yFT/Y4xlI83dl5o6v3njriiLI1ToX5k18vUGtqsgnfZI1q3Om1RgQGp8o5ufumiCZsuVRc1Eh3ysNjemCKErXe5ChLsPPHpV2LP7MG;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Date: Thu, 24 Jul 2008 15:06:58 -0700
User-Agent: KMail/1.9.9
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <200807241407.18543.jbarnes@virtuousgeek.org> <20080724235127.40bd0ac9@mjolnir.drzeus.cx>
In-Reply-To: <20080724235127.40bd0ac9@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241506.58973.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 2:51 pm Pierre Ossman wrote:
> On Thu, 24 Jul 2008 14:07:18 -0700
>
> Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> > On Thursday, July 24, 2008 1:39 pm Pierre Ossman wrote:
> > > This is a laptop with a single expressport that worked fine up until
> > > this merge window. What changed and why is it no longer possible to
> > > support this hardware without a kernel parameter?
> >
> > Yeah we're being a bit more careful about registering hotplug slots these
> > days.  The fact that you got a conflict message indicates that more than
> > one driver is trying to bind to that PCIe port and handle hotplug for it.
> >  I guess acpiphp must already be loaded?
>
> Nope. Only pciehp is builtin, and acpiphp is not loaded. Anything
> non-hotplug related that can block stuff?

Theoretically only one of the other hotplug drivers could claim the slot (e.g. 
acpi, cpci, cpqhp, fakephp etc.).  You could put a dump_stack() or something 
into drivers/pci/hotplug/pci_hotplug_core.c:pci_hp_register to see if we're 
getting multiple callers on the same slot for some reason...  Maybe the 
pciehp driver itself is trying to register the same slot twice?

> Anyway, the port seems to work even with that warning present though
> (sorry for not testing that properly earlier). Stray warnings is still
> not pleasant though, so I can do some more testing if you have some
> ideas.

Thanks.  Yeah we don't want to scare people or break existing setups.

Jesse
