Return-Path: <linux-kernel-owner+w=401wt.eu-S1759610AbXKLQuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759610AbXKLQuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758863AbXKLQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:50:22 -0500
Received: from de01egw02.freescale.net ([192.88.165.103]:49422 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754479AbXKLQuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:50:21 -0500
Message-ID: <47388431.3020609@freescale.com>
Date: Mon, 12 Nov 2007 10:49:53 -0600
From: Scott Wood <scottwood@freescale.com>
User-Agent: Mozilla-Thunderbird 2.0.0.4 (X11/20070828)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Jochen Friedrich <jochen@scram.de>,
       "linuxppc-embedded@ozlabs.org" <linuxppc-embedded@ozlabs.org>,
       linux-kernel@vger.kernel.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: Add EXPORT_SYMBOL for symbols required by fs_enet
 and cpm_uart
References: <47373571.3070605@scram.de> <20071111201503.GA18749@infradead.org>
In-Reply-To: <20071111201503.GA18749@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Sun, Nov 11, 2007 at 06:01:37PM +0100, Jochen Friedrich wrote:
>> --- a/arch/powerpc/sysdev/commproc.c
>> +++ b/arch/powerpc/sysdev/commproc.c
>> @@ -51,6 +51,8 @@ static void m8xx_cpm_dpinit(void);
>> static uint host_buffer; /* One page of host buffer */
>> static uint host_end;    /* end + 1 */
>> cpm8xx_t __iomem *cpmp;  /* Pointer to comm processor space */
>> +EXPORT_SYMBOL(cpmp);
> 
> Sorry, but this is a nightmare waiting to happen.  Please define
> proper accessors instead.

We have proper accessors: in_be32, out_be16, etc.

Now, is the huge struct encompassing all of immr space a bad idea? 
Sure.  Are we working towards getting rid of it?  Yes.  Is that a reason 
to keep modules from working in the meantime?  No.

> (And get rid of the typedef while you're at it)

Again, changing all the users is a bit beyond the scope of this patch.

-Scott
