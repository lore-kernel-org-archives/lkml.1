Return-Path: <linux-kernel-owner+w=401wt.eu-S1753890AbYGEPwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890AbYGEPwU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 11:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYGEPwK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 11:52:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59161 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYGEPwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 11:52:08 -0400
Date: Sat, 5 Jul 2008 11:49:51 -0400
From: Alan Cox <alan@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, alan@redhat.com,
       LKML <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: pata_it821x completely broken
Message-ID: <20080705154951.GC20937@devserv.devel.redhat.com>
References: <200807042153.56644.linux@rainbow-software.org> <200807042339.02444.linux@rainbow-software.org> <20080704224636.352e4a7b@lxorguk.ukuu.org.uk> <200807051242.00545.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807051242.00545.linux@rainbow-software.org>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 05, 2008 at 12:41:58PM +0200, Ondrej Zary wrote:
> Samsungs). Seems like any drive that can't do UDMA fails (looks like MWDMA is 
> broken). The controller BIOS creates the array fine but it doesn't work in 

I've no idea if the BIOS firmware mode can do MWDMA to the drives. The actual
interface between the card and the kernel has no mode stuff at all.

> When I force the pass-through mode, it oopses (haven't captured it yet as it's > too long). Forcing pass-through mode works fine with UDMA-capable drives:

Interesting and definitely sounds like a bug.

> 
> Then I created RAID 1 from the Seagate and Quantum drives. No matter if the 
> rebuild process is running or not, the result is the same - the drives that 
> form RAID aren't accessible, the other drives work:

I would imagine the controller fakes a hotplug event when the rebuild finishes
but that is guessing. The firmware mode is pretty minimally documented.


