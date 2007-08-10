Return-Path: <linux-kernel-owner+w=401wt.eu-S1761658AbXHJA1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761658AbXHJA1P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 20:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXHJA1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 20:27:00 -0400
Received: from rv-out-0910.google.com ([209.85.198.184]:29371 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbXHJA07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 20:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F1ttqoVmvTeIL3xY70gT6Dm29mbcvA90L56UGWKQ5xQ6gyapvIRk2kqc3Wr1n2Jzutc6Kh0aGAYn4Z4c/lEVloLPWOA4Ly0KlfSSk1EYExjTRFq3TI2+TxZNa/qtVZC9o+JQrwq/uXaI3uBx/dHmckR3kilvSPnZQgAlPfW5280=
Message-ID: <dc1166600708091726o434502ffj3309a4fc7caf90b5@mail.gmail.com>
Date: Fri, 10 Aug 2007 10:26:58 +1000
From: "Michael Ellerman" <michael@ellerman.id.au>
To: "Arnd Bergmann" <arnd@arndb.de>
Subject: Re: SLUB doesn't work with kdump kernel on Cell
Cc: ljhc@br.ibm.com, linux-kernel@vger.kernel.org,
       "Christoph Lameter" <clameter@sgi.com>,
       "Arnd Bergmann" <arndb@arndb.de>, cbe-oss-dev@ozlabs.org
In-Reply-To: <200708082310.59997.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1186604151.3608.46.camel@localhost.localdomain>
	 <200708082310.59997.arnd@arndb.de>
X-Google-Sender-Auth: efe1bb2ee4803045
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/9/07, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 08 August 2007, Lucio Correia wrote:
> > DMA 0 -> 12288
> > Normal 12288 -> 12288
> > early_node_map[2] active PFN ranges
> > 0: 0 -> 2560
> > 1: 12287 -> 12288
>
> As Christoph found, this memory map is really strange. Other machines
> have something like
>
> Zone PFN ranges:
>   DMA             0 ->    16384
>   Normal      16384 ->    16384
> early_node_map[2] active PFN ranges
>     0:        0 ->     8192
>     1:     8192 ->    16384
>
> Lucio,
> What code builds the memory map that gets passed to the kdump kernel?
> Does the original kernel see the same map on your machine?

I'd have to check, but I'd guess it's the reserved region for RTAS.
You can confirm by checking the boot log to see where prom_init
instanciated RTAS.

cheers
