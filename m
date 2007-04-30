Return-Path: <linux-kernel-owner+w=401wt.eu-S1161648AbXD3Ftf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161648AbXD3Ftf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 01:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161650AbXD3Ftf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 01:49:35 -0400
Received: from smtp106.plus.mail.re2.yahoo.com ([206.190.53.31]:31955 "HELO
	smtp106.plus.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161648AbXD3Fte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 01:49:34 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.de;
  h=Received:X-YMail-OSG:Received:Date:From:To:Cc:Subject:Message-ID:Reply-To:References:MIME-Version:Content-Type:Content-Disposition:Content-Transfer-Encoding:In-Reply-To:User-Agent;
  b=NO/zv3qjNevoR7seu9AdJ4vz6QxF847SlPXDP7aO6TxXTZfLpA9+M+uuOJGiytw1V+oDoQghPnYfmRhypxmVWNCQnZYxeO+dh8iCCI/cOtxj3AL4gQPEGIzm6Gf/7S44XcQAYBZ1ZelYh1fMyXpI8qNrksI6G8uKHExLwJ5UhGY=  ;
X-YMail-OSG: jvrNSzsVM1l1bkFaih1mWm5Cs3vJmOqVfGTRmlgb4.87.aB2weGRVrxY6uVHsLHCOpRIovoOgA--
Date: Mon, 30 Apr 2007 07:49:27 +0200
From: Borislav Petkov <bbpetkov@yahoo.de>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [9/26] x86_64: Fix vmalloc_32 to really allocate <4GB on 64bit platforms
Message-ID: <20070430054927.GB4772@gollum.tnic>
Reply-To: bbpetkov@yahoo.de
References: <20070430146.588463000@suse.de> <20070429234618.4CC7E150F2@wotan.suse.de> <20070430050133.GA4772@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070430050133.GA4772@gollum.tnic>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I meant this one:


Index: 2.6.21/mm/vmalloc.c
===================================================================
--- 2.6.21.orig/mm/vmalloc.c
+++ 2.6.21/mm/vmalloc.c
@@ -577,6 +577,16 @@ void *vmalloc_exec(unsigned long size)
 	return __vmalloc(size, GFP_KERNEL | __GFP_HIGHMEM, PAGE_KERNEL_EXEC);
 }
 
+#if defined(CONFIG_64BIT)
+  #if defined(CONFIG_ZONE_DMA32)
+  #define GFP_VMALLOC32 GFP_DMA32
+  #elif defined(CONFIG_ZONE_DMA)
+  #define GFP_VMALLOC32 GFP_DMA
+  #endif
+#else
+  #define GFP_VMALLOC32 GFP_KERNEL
+#endif
+
 /**
  *	vmalloc_32  -  allocate virtually contiguous memory (32bit addressable)
  *	@size:		allocation size
-- 
Regards/Gruﬂ,
    Boris.
