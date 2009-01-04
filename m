Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbZADMTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbZADMTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 07:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZADMTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 07:19:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750696AbZADMTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 07:19:10 -0500
Date: Sun, 4 Jan 2009 12:19:09 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Tollef Fog Heen <tfheen@err.no>
Cc: linux-kernel@vger.kernel.org, werner@cornelius-consult.de,
       frank@kingswood-consulting.co.uk
Subject: Re: [PATCH] Winchiphead 340/1: full baud rate and status/control
 line support
Message-ID: <20090104121909.3e4de876@lxorguk.ukuu.org.uk>
In-Reply-To: <87sknzs79y.fsf@qurzaw.linpro.no>
References: <200807290254.m6T2sIBG010575@imap1.linux-foundation.org>
	<20080729104331.367fde6b@lxorguk.ukuu.org.uk>
	<87ej3d4zv3.fsf_-_@xoog.err.no>
	<20080921151407.10c89452@lxorguk.ukuu.org.uk>
	<87sknzs79y.fsf@qurzaw.linpro.no>
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

> | 
> | This could race another set_handshake ? I'm not sure it matters and I'd
> | suggest that stuff gets fixed after this is submitted separately
> 
> What's the easiest way to fix this?

It can sleep so probably all the cases where handshake lines are updated
need to use a mutex to protect them. That will depend if any occur in the
IRQ paths in which case it gets a lot trickier.
