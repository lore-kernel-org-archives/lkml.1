Return-Path: <linux-kernel-owner+w=401wt.eu-S1031253AbXEASce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031253AbXEASce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 14:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031243AbXEAScd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 14:32:33 -0400
Received: from gherkin.frus.com ([192.158.254.49]:47394 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031253AbXEAScc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 14:32:32 -0400
Subject: Re: BAD_SG_DMA panic in aha1542
In-Reply-To: <20070501144623.361d37f0@the-village.bc.nu> "from Alan Cox at May
 1, 2007 02:46:23 pm"
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 1 May 2007 13:32:30 -0500 (CDT)
CC: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070501183230.C7F44DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> The one I sent has a memory leak but it won't matter for basic testing.
> Or you can change the final bit to
> 
> 
>         scsi_normalize_sense((char *)sense, sizeof(*sense), &sshdr);
>         
>         if (zebedee != cgc->buffer) {
>                 if (cgc->data_direction == DMA_FROM_DEVICE)    
>                         memcpy(cgc->buffer, zebedee, cgc->buflen);
>                 kfree(zebedee); /* Time for bed */        
>         }

I changed it, because I'll be living with this for a while I'd bet...

Works fine.  No more BAD_SG_DMA() calls.  Thanks!

-- 
-----------------------------------------------------------------------
Bob Tracy                   WTO + WIPO = DMCA? http://www.anti-dmca.org
rct@frus.com
-----------------------------------------------------------------------
