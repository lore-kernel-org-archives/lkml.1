Return-Path: <linux-kernel-owner+w=401wt.eu-S1757984AbXJKHhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757984AbXJKHhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 03:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755742AbXJKHhc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 03:37:32 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:41249 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366AbXJKHha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 03:37:30 -0400
Date: Thu, 11 Oct 2007 11:35:37 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Josh Triplett <josh@freedesktop.org>
Cc: Al Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org,
       davej@codemonkey.org.uk, Pierre Ossman <drzeus@drzeus.cx>,
       akpm@osdl.org, linux-sparse@vger.kernel.org
Subject: Re: idio{,ma}tic typos (was Re: + fix-vm_can_nonlinear-check-in-sys_remap_file_pages.patch added to -mm tree)
Message-ID: <20071011073537.GA6697@localhost.sw.ru>
References: <20071010104540.GA6366@localhost.sw.ru> <470CBB6A.7020305@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470CBB6A.7020305@freedesktop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2007 at 04:45:46AM -0700, Josh Triplett wrote:
> Alexey Dobriyan wrote:
> > ["if (!x & y)" patch from yanzheng@]
> > ["if (!x & y)" patch from adobriyan@]
> > ["if (!x & y)" patches from viro@]
> > 
> > While we're at it, below is somewhat ugly sparse patch for detecting
> > "&& 0x" typos.
> 
> Excellent idea!  I think it applies to || as well.

Sadly, yes.

[PATCH] smctr: fix "|| 0x" typo

IBM_PASS_SOURCE_ADDR is 1, so logically ORing it with status bits is
pretty useless. Do bitwise OR, instead.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 drivers/net/tokenring/smctr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/tokenring/smctr.c
+++ b/drivers/net/tokenring/smctr.c
@@ -3413,7 +3413,7 @@ static int smctr_make_tx_status_code(struct net_device *dev,
         tsv->svi = TRANSMIT_STATUS_CODE;
         tsv->svl = S_TRANSMIT_STATUS_CODE;
 
-        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) || IBM_PASS_SOURCE_ADDR);
+        tsv->svv[0] = ((tx_fstatus & 0x0100 >> 6) | IBM_PASS_SOURCE_ADDR);
 
         /* Stripped frame status of Transmitted Frame */
         tsv->svv[1] = tx_fstatus & 0xff;

> I'll most likely
> add a -Wboolean-logic-on-bit-constant to turn this warning on.

Ewww, more options. :-(

> Any reason why this wouldn't apply to octal constants or to GCC's new
> binary constants?  I can trivially modify this patch to handle those
> as well, just by dropping the check for an 'x' or 'X', and renaming the
> flag.

OK, let me try too.

