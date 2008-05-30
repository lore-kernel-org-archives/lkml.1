Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbYE3EZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbYE3EZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYE3EZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:25:26 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:10617 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224AbYE3EZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:25:25 -0400
Date: Thu, 29 May 2008 21:38:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Fabio Comolli" <fabio.comolli@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       sam@ravnborg.org
Subject: Re: Section mismatch on latest git
Message-Id: <20080529213845.d013a65e.randy.dunlap@oracle.com>
In-Reply-To: <20080529000128.a106a7b1.akpm@linux-foundation.org>
References: <b637ec0b0805260103w62c03d07ic7bcd0ed0d9c9941@mail.gmail.com>
	<20080529000128.a106a7b1.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 May 2008 00:01:28 -0700 Andrew Morton wrote:

> On Mon, 26 May 2008 10:03:21 +0200 "Fabio Comolli" <fabio.comolli@gmail.com> wrote:
> 
> > Hi.
> > I don't know it it has been reported already:
> > 
> > WARNING: vmlinux.o(.text+0x114bb): Section mismatch in reference from
> > the function nopat() to the function .cpuinit.text:pat_disable()
> > The function nopat() references
> > the function __cpuinit pat_disable().
> > This is often because nopat lacks a __cpuinit
> > annotation or the annotation of pat_disable is wrong.
> > 
> > Config is in attachment.
> > 
> 
> This should fix it:
> 
> --- a/arch/x86/mm/pat.c~arch-x86-mm-patc-nopat-should-be-__init
> +++ a/arch/x86/mm/pat.c
> @@ -34,7 +34,7 @@ void __cpuinit pat_disable(char *reason)
>  	printk(KERN_INFO "%s\n", reason);
>  }
>  
> -static int nopat(char *str)
> +static int __init nopat(char *str)
>  {
>  	pat_disable("PAT support disabled.");
>  	return 0;
> _
> 
> 
> It turns out that this was harmless.  However it might not have been -
> I think that adding the ability to suppress all these warnings was a
> mistake.  

It certainly has caused me to stop looking for/at them.
More a sin of omission than one of commission.

---
~Randy
"He closes his eyes and drops the goggles.  You can't get hurt
by looking at a bitmap.  Or can you?"
