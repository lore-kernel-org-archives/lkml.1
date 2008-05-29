Return-Path: <linux-kernel-owner+w=401wt.eu-S1752514AbYE2HBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752514AbYE2HBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 03:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751168AbYE2HBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 03:01:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47634 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbYE2HBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 03:01:33 -0400
Date: Thu, 29 May 2008 00:01:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: Section mismatch on latest git
Message-Id: <20080529000128.a106a7b1.akpm@linux-foundation.org>
In-Reply-To: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
References: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008 10:03:21 +0200 "Fabio Comolli" <fabio.comolli@gmail.com> wrote:

> Hi.
> I don't know it it has been reported already:
> 
> WARNING: vmlinux.o(.text+0x114bb): Section mismatch in reference from
> the function nopat() to the function .cpuinit.text:pat_disable()
> The function nopat() references
> the function __cpuinit pat_disable().
> This is often because nopat lacks a __cpuinit
> annotation or the annotation of pat_disable is wrong.
> 
> Config is in attachment.
> 

This should fix it:

--- a/arch/x86/mm/pat.c~arch-x86-mm-patc-nopat-should-be-__init
+++ a/arch/x86/mm/pat.c
@@ -34,7 +34,7 @@ void __cpuinit pat_disable(char *reason)
 	printk(KERN_INFO "%s\n", reason);
 }
 
-static int nopat(char *str)
+static int __init nopat(char *str)
 {
 	pat_disable("PAT support disabled.");
 	return 0;
_


It turns out that this was harmless.  However it might not have been -
I think that adding the ability to suppress all these warnings was a
mistake.  
