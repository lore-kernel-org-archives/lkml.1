Return-Path: <linux-kernel-owner+w=401wt.eu-S1756157AbYAEQcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157AbYAEQcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 11:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755107AbYAEQcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 11:32:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59005 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753549AbYAEQcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 11:32:02 -0500
Date: Sat, 5 Jan 2008 16:30:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Al Boldi <a1426z@gawab.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Forcing modes in libata (was: SATA buffered read VERY slow)
Message-ID: <20080105163016.608b1e7f@lxorguk.ukuu.org.uk>
In-Reply-To: <200801051641.03927.a1426z@gawab.com>
References: <200801051641.03927.a1426z@gawab.com>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.3; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Jan 2008 16:41:03 +0300
Al Boldi <a1426z@gawab.com> wrote:

> What's hindering the ability to force a mode in libata, as is possible with 
> the normal ide-driver?

We want it to be correct and race free. That means we have to synchronize
all the devices on the controller, quiesce them and recompute the speeds
for each device then turn them all back on and resume command processing.

It is quite hairy although Tejun's EH work has provided the framework for
all of this.

For now you can boot with libata.dma=1 to select DMA on disks but not CD
