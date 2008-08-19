Return-Path: <linux-kernel-owner+w=401wt.eu-S1755826AbYHSRdN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbYHSRdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 13:33:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbYHSRc6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 13:32:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52624 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225AbYHSRc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 13:32:57 -0400
Date: Tue, 19 Aug 2008 18:14:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       jirislaby@gmail.com
Subject: Re: [PATCH] vt: kill tty->count usage (v2)
Message-ID: <20080819181443.2c1dbbf8@lxorguk.ukuu.org.uk>
In-Reply-To: <20080819170317.GC7154@redhat.com>
References: <20080808213625.GK20355@redhat.com>
	<20080808222635.4fe52b51@lxorguk.ukuu.org.uk>
	<20080812145812.GH7154@redhat.com>
	<20080818181902.59ac763b@lxorguk.ukuu.org.uk>
	<20080818210414.GB7154@redhat.com>
	<20080819160318.26f70590@lxorguk.ukuu.org.uk>
	<20080819170317.GC7154@redhat.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> isn't too late for drivers that wait for the remaining data to be transmitted
> such as amiserial and cyclades? Unless there's a plan to do it at
> release_dev()?

Agreed: waiting for data to be transmitted is one thing, freeing resources
another. We don't want to be freeing resources until the tty object is
destructed. Also most drivers won't be able to block there as they will
be using krefs to the tty and thus potentially destructing it from an IRQ
handler.
