Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXFLBu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXFLBu6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:50:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756183AbXFLBuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:50:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47293 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582AbXFLBuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:50:51 -0400
Date: Tue, 12 Jun 2007 10:50:33 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: mm: memory/cpu hotplug section mismatch.
Cc: Paul Mundt <lethal@linux-sh.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070611184046.GA6458@uranus.ravnborg.org>
References: <20070611154428.GA27644@linux-sh.org> <20070611184046.GA6458@uranus.ravnborg.org>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20070612102236.E8BA.Y-GOTO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.27 [ja]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > If CONFIG_MEMORY_HOTPLUG=n __meminit == __init, and if
> > CONFIG_HOTPLUG_CPU=n __cpuinit == __init. However, with one set and the
> > other disabled, you end up with a reference between __init and a regular
> > non-init function.
> 
> My plan is to define dedicated sections for both __devinit and __meminit.
> Then we can apply the checks no matter the definition of CONFIG_HOTPLUG*

I prefer defining "__nodeinit" for __cpuinit and __meminit case to
__devinit.   __devinit is used many devices like I/O, and it is
useful for many desktop users. But, cpu/memory hotpluggable box
is very rare. And it should be in init section for many people.

This kind of issue is caused by initialization of pgdat/zone.
I think __nodeinit is enough and desirable.

Bye.

-- 
Yasunori Goto 


