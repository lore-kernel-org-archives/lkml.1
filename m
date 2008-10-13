Return-Path: <linux-kernel-owner+w=401wt.eu-S1757566AbYJMOiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbYJMOiN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 10:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbYJMOhz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 10:37:55 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52936 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755272AbYJMOhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 10:37:54 -0400
Date: Mon, 13 Oct 2008 15:37:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] mptsas: remove pointless null check
Message-ID: <20081013153701.61f22485@lxorguk.ukuu.org.uk>
In-Reply-To: <1223907778.5566.3.camel@localhost.localdomain>
References: <20081006172653.GA26427@oksana.dev.rtsoft.ru>
	<48F2F138.6020103@kernel.org>
	<48F34CB9.3020000@pobox.com>
	<20081013150529.75f22702@lxorguk.ukuu.org.uk>
	<1223907778.5566.3.camel@localhost.localdomain>
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

> If I remember rightly this check is necessary because phy_info can be
> NULL in certain situations.  Your patch will trip this to oops.  What

In which case it will already have crashed

> your description needs to say is that we no longer need to check this
> pointer for NULL because it was checked somewhere else in the stack ...
> but I can't see where that is, where is it?

We don't check: but if it was NULL we then fall straight through and
dereference it unconditionally... so either its a wrong NULL check and
the old code oopses (which a trawl says it doesn't) or the check is bogus.

Alan
