Return-Path: <linux-kernel-owner+w=401wt.eu-S1753359AbZGKBst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359AbZGKBst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751184AbZGKBsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:48:41 -0400
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:36189 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123AbZGKBsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:48:41 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=ETBUO8ZmUtVq3xOXUtSxpSsu3jcS/BTrmVU5q4DdJggzF2EfM8tjIj59CsiwSnl6;
  h=Received:Cc:Message-Id:From:To:In-Reply-To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:References:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Cc: linux-kernel@vger.kernel.org
Message-Id: <2AF5E97B-E5D6-4302-9C13-30B2270F15D3@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: Mitchell Erblich <erblichs@earthlink.net>
In-Reply-To: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: Suggested code change : Simple : Scale pdflush threads from desktop to server
Date: Fri, 10 Jul 2009 18:48:39 -0700
References: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec799b09853adca3b8c2f783fbf59997e12d350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry,

	IF Not rate limit. Missing not / !.
	if (!(printk_ratelimit() )) {


	Mitchell Erblich	
	================
	
On Jul 10, 2009, at 6:25 PM, Mitchell Erblich wrote:

> Group,
>
> 		pdflush threads clean dirty pages
>
> 	  Under the past simple assumption that a greater number of
> 	  page daemon threads will have the TENDENCY to clean
> 	  the pages faster.
>
> 	Another assumption is that a server will have at least 2x / 4x the
> 	number of drives and memory, so allocating more pdflush() threads
> 	makes sense.
>
> 	Relying on a recent change, code base on whether the system is
> 	a desktop or a server, scale the number of pdthreads() which would
> 	result in the below code change.
>
> 	The suggestion is to double the MIN number of threads and set the
> 	MAX number to 4x.
>
> 	./mm/pdflush.c
> 	/* Scale for a server */
> 	#define MIN_PDFLUSH_THREADS 	4		/* 2x desktop value */
> 	#define MAX_PDFLUSH_THREADS 	32		/* 4x desktop value */
>
>
> 	/*
> 	 * secondary suggestion is to add a DEBUG type /var/log/system  
> messages that
> 	 * will rate limit independent of desktop or server.
>         */
>
> 	else if (nr_pdflush_threads == MAX_PDFLUSH_THREADS) {
> 		   /* optional PDFLUSH msg */
> 		   if (printk_ratelimit() {
> 	 		                            printk(KERN_INFO  
> "MAX_PDFLUSH_THREADS Limited\n");
>                   }
>         }
> 	
>
> 	

