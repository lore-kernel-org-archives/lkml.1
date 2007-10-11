Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXJKQ1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXJKQ1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXJKQ13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:27:29 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:33321 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463AbXJKQ12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:27:28 -0400
Message-ID: <470E4EE9.1020102@freedesktop.org>
Date: Thu, 11 Oct 2007 09:27:21 -0700
From: Josh Triplett <josh@freedesktop.org>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, Pierre Ossman <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch
 added to -mm tree)
References: <20071010104540.GA6366@localhost.sw.ru> <470CBB6A.7020305@freedesktop.org> <20071011073537.GA6697@localhost.sw.ru>
In-Reply-To: <20071011073537.GA6697@localhost.sw.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Wed, Oct 10, 2007 at 04:45:46AM -0700, Josh Triplett wrote:
>> Alexey Dobriyan wrote:
>>> ["if (!x & y)" patch from yanzheng@]
>>> ["if (!x & y)" patch from adobriyan@]
>>> ["if (!x & y)" patches from viro@]
>>>
>>> While we're at it, below is somewhat ugly sparse patch for detecting
>>> "&& 0x" typos.
>> Excellent idea!  I think it applies to || as well.
> 
> Sadly, yes.
> 
> [PATCH] smctr: fix "|| 0x" typo
> 
> IBM_PASS_SOURCE_ADDR is 1, so logically ORing it with status bits is
> pretty useless. Do bitwise OR, instead.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
> 
>  drivers/net/tokenring/smctr.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/drivers/net/tokenring/smctr.c
> +++ b/drivers/net/tokenring/smctr.c
> @@ -3413,7 +3413,7 @@ static int smctr_make_tx_status_code(struct net_device *dev,
>          tsv->svi = TRANSMIT_STATUS_CODE;
>          tsv->svl = S_TRANSMIT_STATUS_CODE;
>  
> -        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) || IBM_PASS_SOURCE_ADDR);
> +        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) | IBM_PASS_SOURCE_ADDR);
>  
>          /* Stripped frame status of Transmitted Frame */
>          tsv->svv[1] = tx_fstatus & 0xff;

Nice catch.  I agree with Kyle, though, that fixing it may require
some care to make sure it doesn't break things relying on the bug.

>> I'll most likely
>> add a -Wboolean-logic-on-bit-constant to turn this warning on.
> 
> Ewww, more options. :-(

With heuristic warnings like this, people need a way to turn them off.

>> Any reason why this wouldn't apply to octal constants or to GCC's new
>> binary constants?  I can trivially modify this patch to handle those
>> as well, just by dropping the check for an 'x' or 'X', and renaming the
>> flag.
> 
> OK, let me try too.

Go for it.  I look forward to your next patch.

Thanks,
Josh Triplett
