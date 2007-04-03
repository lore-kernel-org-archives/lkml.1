Return-Path: <linux-kernel-owner+w=401wt.eu-S1161041AbXDCRu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161041AbXDCRu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161042AbXDCRuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:50:25 -0400
Received: from smtp009.mail.ukl.yahoo.com ([217.12.11.63]:39902 "HELO
	smtp009.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1161041AbXDCRuV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:50:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=BMRyPXhOoa2jIg3Tz7RsneBxVzG6HwHsZwYdPofd3CQJNoWUIYGj+6bnWZhAxRr0SnDQzXdgO5HAr/8EYvu15wzOBbbbooHlekgi4aP/wzFskLksLceue37QYVE0alMzwupt6vZ+434aX1yVWyfOTepcf0817w3WFFTlS22cQjw=  ;
X-YMail-OSG: CtVyDVcVM1nnvyub3lynwVoxrSNLno4y_Ok6rSQLc.My7qsLyXqbUqL_biqGu4Id7JjT34nwC7quL_Cb8872JK00GOuWZwUdBebdcqzittK85Dzv
From: Blaisorblade <blaisorblade@yahoo.it>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 2/4] UML - tidy process.c
Date: Tue, 3 Apr 2007 19:50:16 +0200
User-Agent: KMail/1.9.6
Cc: Jeff Dike <jdike@addtoit.com>, Andrew Morton <akpm@osdl.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070402165011.GA7616@c2.user-mode-linux.org>
In-Reply-To: <20070402165011.GA7616@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704031950.17109.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On lunedì 2 aprile 2007, Jeff Dike wrote:
> Clean up arch/um/kernel/process.c -
> 	lots of return(x); -> return x; conversions
> 	a number of the small functions are either unused, in which
> case they are gone, along any declarations in a header, or could be
> made static.

> 	current_pid is ifdefed on CONFIG_MODE_TT and its declaration
> is ifdefed on both CONFIG_MODE_TT and UML_CONFIG_MODE_TT because we
> don't know whether it's being used in a userspace or kernel file.

Please, simply include uml-config.h and use just UML_CONFIG_MODE_TT.

> Index: linux-2.6.21-mm/arch/um/include/kern_util.h
> ===================================================================
> --- linux-2.6.21-mm.orig/arch/um/include/kern_util.h	2007-03-30
> 16:01:21.000000000 -0400 +++
> linux-2.6.21-mm/arch/um/include/kern_util.h	2007-04-02 12:07:48.000000000
> -0400 @@ -33,7 +33,9 @@ extern int nsyscalls;
>  	UML_ROUND_DOWN(((unsigned long) addr) + PAGE_SIZE - 1)
>
>  extern int kernel_fork(unsigned long flags, int (*fn)(void *), void *
> arg); +#if defined(CONFIG_MODE_TT) || defined(UML_CONFIG_MODE_TT)
>  extern unsigned long stack_sp(unsigned long page);
> +#endif
>  extern int kernel_thread_proc(void *data);
>  extern void syscall_segv(int sig);
>  extern int current_pid(void);



-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
