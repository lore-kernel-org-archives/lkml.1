Return-Path: <linux-kernel-owner+w=401wt.eu-S1756509AbYJ3Ajj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509AbYJ3Ajj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 20:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755740AbYJ3Aja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 20:39:30 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57861 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755063AbYJ3Aj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 20:39:29 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=6K9UcZB1irvz1XBPfZkA:9 a=TYm2aEzDoQ08VyJ9UXkA:7 a=iTfKDgIDfxDTUjOO2W9c-6yiIe8A:4 a=MSl-tDqOz04A:10 a=JfD0Fch1gWkA:10 a=D4FwsTI08Q0A:10 a=BjSCe7YdmnEA:10
Message-ID: <4909023E.60806@shaw.ca>
Date: Wed, 29 Oct 2008 18:39:26 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: "Phillip O'Donnell" <phillip.odonnell@gmail.com>, jeff@garzik.org,
       Oskar Liljeblad <oskar@osk.mine.nu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal
 > 127
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no> <fa.Dwk+NgWNu7+JRcsgOPCxSr7y5SQ@ifi.uio.no> <fa.fIxdVik0iPc+lS+sd5ef+ZoALzQ@ifi.uio.no>
In-Reply-To: <fa.fIxdVik0iPc+lS+sd5ef+ZoALzQ@ifi.uio.no>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
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

This should be pushed to -stable as well once it's merged..
