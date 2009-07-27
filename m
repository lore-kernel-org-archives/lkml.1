Return-Path: <linux-kernel-owner+w=401wt.eu-S1755196AbZG0Vnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbZG0Vnu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 17:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZG0Vnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 17:43:49 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:55844 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753887AbZG0Vnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 17:43:49 -0400
Date: Mon, 27 Jul 2009 17:43:40 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
In-Reply-To: <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0907271740090.27697@gentwo.org>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.Pi.BZObKB@chimera> <4A6CF220.7080605@lwfinger.net> <alpine.DEB.2.00.0907261722140.21259@chino.kir.corp.google.com> <84144f020907270008h2a985278of68e70ff1ee9265c@mail.gmail.com>
 <alpine.DEB.2.00.0907270227420.15760@chino.kir.corp.google.com> <alpine.DEB.1.10.0907271320130.13513@gentwo.org> <alpine.DEB.2.00.0907271113460.8408@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009, David Rientjes wrote:

> My patch is already in Pekka's slab-2.6.git tree at
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commit;h=fa5ec8a1f66f3c2a3af723abcf8085509c9ee682
>
> You had proposed http://marc.info/?l=linux-kernel&m=124725166205814, which
> moves the mask to kmem_cache_open() and calls calculate_sizes() twice.
> That eliminates DEBUG_FLAGS_SIZE, but I don't see that define as being
> troublesome since we must define DEBUG_FLAGS to specify what options add
> metdata anyway.

My prosal was to use the size and objsize parameters. You would only have
to call calculate_sizes() twice when the comparison of the order of size
and objsize would be different.

Doing so would simplify additing future flags. If you do your own
calculations (like in the patch) then you have to replicate the size
calculation from calculate_sizes() somehow. Is the duplicate calculation
really accurate regarding alignment and other special casing?



