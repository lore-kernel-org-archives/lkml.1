Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZIGMl4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZIGMl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:41:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbZIGMlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:41:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbZIGMly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:41:54 -0400
Date: Mon, 7 Sep 2009 08:41:54 -0400 (EDT)
From: Miroslav Rezanina <mrezanin@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
       Gianluca Guida <gianluca.guida@citrix.com>
Message-ID: <1864241231.701071252327314933.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4A8D7C26.5020902@goop.org>
Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


----- "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

> From: "Jeremy Fitzhardinge" <jeremy@goop.org>
> To: "Miroslav Rezanina" <mrezanin@redhat.com>
> Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com, "Gianluca Guida" <gianluca.guida@citrix.com>
> Sent: Thursday, August 20, 2009 6:39:02 PM GMT +01:00 Amsterdam / Berlin / Bern / Rome / Stockholm / Vienna
> Subject: Re: [PATCH][v2.6.29][XEN] Return unused memory to hypervisor
>
> On 08/20/09 00:47, Miroslav Rezanina wrote:
> > there is handled e820 map in guest. However, this patch informs 
> > hypervisor, that guest uses less memory than was assigned to it. 
> > If hypervisor is not informed, memory is reserved for guest that
> > do not need it. If hypervisor is informed, he decrease memory
> > reservation for guest and unused memory is marked as free 
> > for use by other guests.
> >   
> 
> Yes.  But the guest will modify its own e820 map for a number of
> reasons; for example: reducing its own memory, or clearing a space
> for
> the PCI hole.  In general we want to free any underlying pages which
> don't correspond to E820_RAM regions.
> 
>     J
> --

Hi Jeremy,
can you give me a practical example, where e820 map can have "hole" inside,
i.e. there will be block of memory not listed in e820 map that have listed 
memory before and after it?
As I checked the source code, there is always removed memory from some point
till end of map, not from one adress till another. And I can't image how would
be such a case handled. Of course, there can be some special regions, as the PCI
hole, but these are marked as "Reserved".
There can be "reserved and returned" some inside memory, but this is already
handled  by balloon driver. My patch returns memory that this driver can't use.
Regards,
Mirek
-- 
Miroslav Rezanina
Software Engineer - Virtualization Team - XEN kernel

