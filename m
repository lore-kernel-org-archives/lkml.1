Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbYEPKJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbYEPKJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752956AbYEPKI5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:08:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34944 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752722AbYEPKI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:08:56 -0400
Date: Fri, 16 May 2008 10:56:35 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jeff Garzik <jeff@garzik.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       Chris Peterson <cpeterso@cpeterso.com>,
       tpmdd-devel@lists.sourceforge.net, tpm@selhorst.net,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Re: [PATCH] drivers/net: remove network drivers' last
 few uses of IRQF_SAMPLE_RANDOM
Message-ID: <20080516105635.6cb1f505@core>
In-Reply-To: <87abirytxj.fsf@basil.nowhere.org>
References: <Pine.LNX.4.62.0805150009060.18303@ikari.dreamhost.com>
	<20080515142154.0595e475@core>
	<36D9DB17C6DE9E40B059440DB8D95F52052D71BB@orsmsx418.amr.corp.intel.com>
	<20080515173939.1ec968be@core>
	<482C7DA3.1090809@garzik.org>
	<482C953A.4080205@garzik.org>
	<87abirytxj.fsf@basil.nowhere.org>
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

On Fri, 16 May 2008 02:27:36 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Jeff Garzik <jeff@garzik.org> writes:
> >
> > A hw_random driver for TPM still needs to (a) parse the TPM header for
> > return code, (b) extract RNG bytes out at offset 14, and (c) figure
> > out some way to get a tpm_chip pointer.
> 
> (d) auto feed the information into random.c. Otherwise it'll be useless
> for most people.

No - you don't want to do FIPS randomness verification in kernel space.
Plus all the other random generator inputs are done via the user space
daemon as they should be.
