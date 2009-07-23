Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbZGWQaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbZGWQaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 12:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbZGWQaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 12:30:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZGWQaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 12:30:18 -0400
Date: Thu, 23 Jul 2009 09:29:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Linux 2.6.31-rc4: strange change in iomem allocation
In-Reply-To: <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0907230926140.21520@localhost.localdomain>
References: <alpine.LFD.2.01.0907221936220.3352@localhost.localdomain> <200907231614.23570.elendil@planet.nl> <200907231653.48933.elendil@planet.nl> <alpine.LFD.2.01.0907230905360.21520@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 23 Jul 2009, Linus Torvalds wrote:
> 
> Don't worry about the new warning. 
> 
> It is in fact _normal_ to see a number of warnings about PnP resources 
> "could not be reserved"

In fact, I notice that you had them even before, eg:

	system 00:00: iomem range 0x0-0x9ffff could not be reserved
	system 00:00: iomem range 0xe0000-0xfffff could not be reserved
	system 00:00: iomem range 0x100000-0x7e7fffff could not be reserved

which are about exactly the same thing - e820 RAM reservations take 
precedence over the PnP ones.

So the only new thing is that we claim the APIC thing to that category 
too.

		Linus
