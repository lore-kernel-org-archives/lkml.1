Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbYJaFqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbYJaFqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 01:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYJaFp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 01:45:59 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50944 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800AbYJaFp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 01:45:59 -0400
Message-ID: <490A9B8C.9000704@garzik.org>
Date: Fri, 31 Oct 2008 01:45:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "Phillip O'Donnell" <phillip.odonnell@gmail.com>,
       Oskar Liljeblad <oskar@osk.mine.nu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal
 > 127
References: <20081028170105.GA21933@osk.mine.nu>	<7a9b5c320810281625kbf8904x9ba432ff0ca8c2f8@mail.gmail.com> <ada4p2wmg5n.fsf_-_@cisco.com>
In-Reply-To: <ada4p2wmg5n.fsf_-_@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> In ata_tf_to_lba48(), when evaluating
> 
> 	(tf->hob_lbal & 0xff) << 24
> 
> the expression is promoted to signed int (since int can hold all values
> of u8).  However, if hob_lbal is 128 or more, then it is treated as a
> negative signed value and sign-extended when promoted to u64 to | into
> sectors, which leads to the MSB 32 bits of section getting set
> incorrectly.
> 
> For example, Phillip O'Donnell <phillip.odonnell@gmail.com> reported
> that a 1.5GB drive caused:
> 
>     ata3.00: HPA detected: current 2930277168, native 18446744072344861488
> 
> where 2930277168 == 0xAEA87B30 and 18446744072344861488 == 0xffffffffaea87b30
> which shows the problem when hob_lbal is 0xae.
> 
> Fix this by adding a cast to u64, just as is used by for hob_lbah and
> hob_lbam in the function.
> 
> Reported-by: Phillip O'Donnell <phillip.odonnell@gmail.com>
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> ---
> Phillip, this should fix at least your cosmetic issue; can you test it
> and report back?
> 
> Thanks,
>   Roland
> 
>  drivers/ata/libata-core.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

applied


