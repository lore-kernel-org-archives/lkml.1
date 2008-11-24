Return-Path: <linux-kernel-owner+w=401wt.eu-S1753629AbYKXTGB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbYKXTGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 14:06:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751506AbYKXTFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 14:05:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:41359 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750890AbYKXTFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 14:05:53 -0500
Date: Mon, 24 Nov 2008 18:54:53 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mel Gorman <mel@csn.ul.ie>
Cc: petkovbb@gmail.com, sshtylyov@ru.mvista.com, linux-kernel@vger.kernel.org
Subject: Re: Is the change to IDE probing really necessary?
Message-ID: <20081124185453.57ca7dcc@lxorguk.ukuu.org.uk>
In-Reply-To: <20081124184321.GA8293@csn.ul.ie>
References: <20081124155632.GE23190@csn.ul.ie>
	<20081124184321.GA8293@csn.ul.ie>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> On a machine requiring probing of the legacy ports, the suggested
> probe_mask of 0x3f results in other devices being registered as IDE
> devices. Suggest to the user they use 0x3 which is the old value of
> probe_mask prior to commit 20df429dd6671804999493baf2952f82582869fa.

NAK

This makes no sense.

0x3F means probe them all.

0x03 means only peer at primary/secondary.

If you don't want them probed, don't pass arguments asking for them to be
probed!

"how is a distro install using modules meant to be fixed up?"

If the distribution supports non PCI bus boxes then pass a mask of 0x3F
on non PCI boxes. If the distribution is for PCI systems then leave the
mask alone.

If you want it to just work automatically use pata_legacy instead as that
automatically flips between probing ISA tertiary devices and leaving
things well alone according to the presence of PCI bus.

Alan
