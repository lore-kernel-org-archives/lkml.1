Return-Path: <linux-kernel-owner+w=401wt.eu-S1764010AbYEFQA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764010AbYEFQA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756384AbYEFQAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:00:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51541 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754646AbYEFQAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:00:38 -0400
Date: Tue, 6 May 2008 16:49:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Shaohua Li <shaohua.li@intel.com>, Holger Macht <hmacht@suse.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Accardi, Kristen C" <kristen.c.accardi@intel.com>
Subject: Re: [PATCH] bay: Exit if notify handler cannot be installed
Message-ID: <20080506164930.32df50d0@core>
In-Reply-To: <20080506153901.GC22828@khazad-dum.debian.net>
References: <20080505202508.GA3690@homac>
	<20080506091522.GA4378@homac>
	<1210065811.12668.1.camel@sli10-desk.sh.intel.com>
	<20080506151846.GA22828@khazad-dum.debian.net>
	<20080506162049.237af49c@core>
	<20080506153901.GC22828@khazad-dum.debian.net>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The problem has a bit of a hard edge, though: if nobody binds to an ACPI
> node that has an EJ0 subnode, bay needs to do it.  But if someone wants
> to, bay should give the node up, and somehow help that someone handle
> the ejection stuff.

A notifier chain should do all that is needed. If bay is loaded anyway
then ATA and other users can register with the bay driver and it can pass
an event to a notifier chain so that anyone who wants that event can act
on it (and if nobody does it can do its own stuff)

Alan
