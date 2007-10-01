Return-Path: <linux-kernel-owner+w=401wt.eu-S1756030AbXJAUHH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbXJAUHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 16:07:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJAUG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 16:06:57 -0400
Received: from n7.bullet.mud.yahoo.com ([216.252.100.58]:47949 "HELO
	n7.bullet.mud.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751484AbXJAUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 16:06:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 600227.37843.bm@omp108.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=JFI93gjpzOHlXrYO0qKiBrK2exRN0OUN5mgune/EHusbnjKGeS2+sEvK9Tn0eMPo1KvwogV0XtXLOa8+OtabFNg6kjPzE6/DBzH/XSkEeYxjkQACFOyyLaFoaEyO6w9yo/TykbbTHV1rzLQEClIKfNh61EHkhDIwEPLSFCcJVpE=;
X-YMail-OSG: 2Ig8bTcVM1nO9td6myIxXt9.FpWVrwmpuK_jDH2VK_Z13tLNAiMLCRCEa2vgXw9UmqssKi2L8wJOBb2MetWIWOxLM0VENOwBoLeO8r.4zPTX.bC6fUVqfh4iVQ--
Date: Mon, 1 Oct 2007 13:10:59 +0100 (BST)
From: veerasena reddy <veerasena_b@yahoo.co.in>
Subject: Re: linux cache routines for Write-back cache policy on  MIPS24KE
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
       "linux-kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071001105954.GB23647@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <535696.48077.qm@web8403.mail.in.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

Thanks for the reply.

Is there any problem if we use the below API's in
linxu-2.6.18 
  - dma_cache_wback_inv()
  - dma_cache_wback()
  - dma_cache_inv()

functionality wise, especially in r4k.c i dont see any
difference between the implementation of these APIs.

Can we apply the 2.6.24 patch to kill these APIs on
2.6.18 kernel? In this case what APIs i can use for
writeback, invalidation or both?

I couldn't find any info. related to the above API in
DMA-API.txt. Could you please give some pointers on
the usage/working of these APIs.

Regards,
Veerasena.

--- Ralf Baechle <ralf@linux-mips.org> wrote:

> On Mon, Oct 01, 2007 at 10:04:32AM +0100, veerasena
> reddy wrote:
> 
> > I have ported Linux-2.6.18 kernel on MIPS24KE
> > processor. I am using write back cache policy.
> > 
> > Could you please guide me under what cases the
> below
> > cache API's are being used:
> > - dma_cache_wback_inv() : Could you explain  what
> > exactly this function does
> > - dma_cache_wback() : This function write back the
> > cache data to memory
> > - dma_cache_inv  : This function invalidate the
> cache
> > tags. so subsequent access will fetch from memory.
> > 
> > Once I looked the above function definitions in
> > linux-2.6.18/arch/mips/mm/c-r4k.c.
> > All these function's implemetation are same except
> > bc_wbak_inv() is called in both
> dma_cache_wback-inv()
> > and dma_cache_wback(), where as bc_inv() is called
> in
> > case of dma_cache_inv.
> > 
> > Also, bc_inv()/bc_wbak_inv are define as null
> > implementation for R4000.
> > That means all three functions are doing same
> > functionality in case of R4000.
> > 
> > What are the difference between these three
> functions.
> > Under what cases these functions are used. 
> 
> An internal only interface to be used with I/O cache
> coherency.
> 
> > Please guide me if you have any links which will
> > explain these API's.
> 
> Easy answer, don't use them, for 2.6.24 I've queued
> a patch to kill this
> API.  Documentation/DMA-API.txt documents how to
> properly deal with I/O
> coherency in Linux.
> 
>   Ralf
> 



      Save all your chat conversations. Find them online at http://in.messenger.yahoo.com/webmessengerpromo.php

