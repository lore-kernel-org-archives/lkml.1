Return-Path: <linux-kernel-owner+w=401wt.eu-S1752909AbYGXVHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752909AbYGXVHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 17:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbYGXVHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 17:07:24 -0400
Received: from outbound-mail-20.bluehost.com ([69.89.20.235]:38597 "HELO
	outbound-mail-20.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751655AbYGXVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 17:07:24 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=uf/STVvvVmy/IWIE3y9kgCvhbQ344ysO4rBFNpevldd4ECQwt80GOoFESE5M5+VqVEyLI6Gtld1fCezujwTEYs1C8Fye0ob06Jo30/ucvMcqd/v4FQk5SUuGg2PurI7S;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Date: Thu, 24 Jul 2008 14:07:18 -0700
User-Agent: KMail/1.9.9
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx> <488877C8.9020706@jp.fujitsu.com> <20080724223920.1f4dd753@mjolnir.drzeus.cx>
In-Reply-To: <20080724223920.1f4dd753@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807241407.18543.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2008 1:39 pm Pierre Ossman wrote:
> On Thu, 24 Jul 2008 21:38:32 +0900
>
> Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:
> > Hi Pierre,
> > (Added linux-pci to CC)
> >
> > Pierre Ossman wrote:
> > > Somewhere post 2.6.26, pciehp started whining about not being able to
> > > claim the slot and error code -17. It suggested adding
> > > "pciehp_slot_with_bus", which actually helped. Still, having a kernel
> > > parameter should just be a temporary fix.
> >
> > The "pciehp_slot_with_bus" option is a workaround for the platforms
> > that assign the same physical slot number to multiple slots. If your
> > system has PCI chassis and it supports Chassis Number registers,
> > maybe one of the solution is using chassis number + slot number as a
> > slot name. But I don't have any idea other than "pciehp_slot_with_bus"
> > if your system doesn't support chassis number.
>
> The what now? :)
>
> This is a laptop with a single expressport that worked fine up until
> this merge window. What changed and why is it no longer possible to
> support this hardware without a kernel parameter?

Yeah we're being a bit more careful about registering hotplug slots these 
days.  The fact that you got a conflict message indicates that more than one 
driver is trying to bind to that PCIe port and handle hotplug for it.  I 
guess acpiphp must already be loaded?

Jesse
