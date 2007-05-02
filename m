Return-Path: <linux-kernel-owner+w=401wt.eu-S1766838AbXEBRQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766838AbXEBRQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 13:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766839AbXEBRQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 13:16:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:10322 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766834AbXEBRQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 13:16:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=dEUC/DoXdC4wLPEzO80Lm2+VvLMZP/wk25YausMjexwGsD5XYEwvoz6MpCfL3BUCQ
	kcB8DtZ1BzvJ9SF+ln/IA==
Date: Wed, 2 May 2007 10:16:15 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Adrian Bunk <bunk@stusta.de>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/10] compiler: define __attribute_unused__
In-Reply-To: <20070502150546.GF3531@stusta.de>
Message-ID: <Pine.LNX.4.64.0705021014070.3033@chino.kir.corp.google.com>
References: <Pine.LNX.4.64.0705012118130.19277@chino.kir.corp.google.com>
 <1178084403.28659.222.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012254160.21685@chino.kir.corp.google.com>
 <1178087393.28659.238.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705012336430.22339@chino.kir.corp.google.com>
 <1178089444.28659.246.camel@localhost.localdomain>
 <Pine.LNX.4.64.0705020020420.22717@chino.kir.corp.google.com>
 <20070502145550.GE3531@stusta.de> <20070502150546.GF3531@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007, Adrian Bunk wrote:

> If we don't want any warnings with CONFIG_PCI=n, CONFIG_SYSFS=n or
> CONFIG_PROC_FS=n, we'd have to annotate _many_ functions.
> 
> If the lonterm goal is to compile the kernel with -Werror then we need 
> -Wno-unused-function, not annotating individual functions.
> 

That's only addressing part of the issue.  What about automatic or static 
external variables that are declared but may go unreferenced depending on 
preprocessor macros?  You need to annotate them with __attribute__ 
((unused)) to suppress compiler warnings.  Globally disabling such 
warnings would eventually cause unused code to go unnoticed.

		David
