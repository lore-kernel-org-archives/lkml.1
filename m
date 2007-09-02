Return-Path: <linux-kernel-owner+w=401wt.eu-S1759630AbXIBUYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630AbXIBUYu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:24:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759910AbXIBUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:24:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:40174 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759139AbXIBUYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:24:05 -0400
Message-ID: <46DB1BDF.4090100@garzik.org>
Date: Sun, 02 Sep 2007 16:23:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       James Bottomley <james.bottomley@steeleye.com>,
       Oliver Neukum <oliver@neukum.name>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] DC395x SCSI driver: Shut up uninitialized variable
 build warning
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030152260.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> drivers/scsi/dc395x.c: In function ‘dc395x_init_one’:
> drivers/scsi/dc395x.c:4272: warning: ‘ptr’ may be used uninitialized in this function
> 
> has been verified to be a bogus warning. Let's shut it up.
> 
> Signed-off-by: Satyam Sharma <satyam@infradead.org>
> 
> ---
> 
>  drivers/scsi/dc395x.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c~fix	2007-09-02 20:57:51.000000000 +0530
> +++ linux-2.6.23-rc4-mm1/drivers/scsi/dc395x.c	2007-09-02 21:10:49.000000000 +0530
> @@ -4269,7 +4269,7 @@ static int __devinit adapter_sg_tables_a
>  	const unsigned srbs_per_page = PAGE_SIZE/SEGMENTX_LEN;
>  	int srb_idx = 0;
>  	unsigned i = 0;
> -	struct SGentry *ptr;
> +	struct SGentry * uninitialized_var(ptr);

For things like this, we need to see (perhaps a separate email in the 
same thread) your build details:  config, arch, compiler version, etc.

This warning does not appear on x86 or x86-64 here, with the current 
version of gcc.  And I'm not so sure we want to be adding these markers 
for older versions of the compiler, or for what is ultimately a 
temporary [situation | configuration] in the grand scheme of things.

I paid careful attention to my recent set of uninitialized_var() markers 
(now upstream), making sure that they persisted across several compiler 
versions, ensuring the warning was not a temporary optimizer bug quickly 
remedied.

I hope to encourage similar diligence in others :)  These markers have 
the very-real potential downside of hiding bugs, so they should be used 
sparingly.

	Jeff


