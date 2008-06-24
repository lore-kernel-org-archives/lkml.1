Return-Path: <linux-kernel-owner+w=401wt.eu-S1754141AbYFXMuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbYFXMuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFXMu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:50:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:52484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751498AbYFXMu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:50:26 -0400
Date: Tue, 24 Jun 2008 13:32:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Elias Oltmanns <eo@nebensachen.de>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] IDE: Fix HDIO_DRIVE_RESET handling
Message-ID: <20080624133218.6bccab75@lxorguk.ukuu.org.uk>
In-Reply-To: <200806241306.42054.bzolnier@gmail.com>
References: <87k5gmz596.fsf@denkblock.local>
	<200806240041.42796.bzolnier@gmail.com>
	<87skv3s3d9.fsf@denkblock.local>
	<200806241306.42054.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I don't see a reliable way to fix ide_abort() - once the request/command
> is started hardware can be already in a state that makes aborting hard if
> not impossible.

It depends on the ATA version what you do but you end up doing a reset
sequence without waiting for the existing command to finish if your drive
is too new to have IDLE IMMEDIATE. What you can't do is wait for the
command to finish before issuing a reset because it may never finish.

I don't see why you think it's "hard". We have timeout handlers for many
commands and those reset/abort just fine.

Alan
