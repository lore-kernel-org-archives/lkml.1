Return-Path: <linux-kernel-owner+w=401wt.eu-S1757892AbZGKBZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757892AbZGKBZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 21:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750872AbZGKBZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 21:25:30 -0400
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:52653 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824AbZGKBZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 21:25:29 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=dk20050327; d=earthlink.net;
  b=LOOwEyh30Fx4cPRUeQJDfpLtlyTz/8WlhQ42/g5Gv61MBljxJsOF77cZ6i8Q/Qpi;
  h=Received:Message-Id:From:To:Content-Type:Content-Transfer-Encoding:Mime-Version:Subject:Date:X-Mailer:X-ELNK-Trace:X-Originating-IP;
Message-Id: <F4B972C6-3FAB-49DB-A409-36B5EF2A7684@earthlink.net>
From: Mitchell Erblich <erblichs@earthlink.net>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Suggested code change : Simple : Scale pdflush threads from desktop to server
Date: Fri, 10 Jul 2009 18:25:26 -0700
X-Mailer: Apple Mail (2.930.3)
X-ELNK-Trace: 074f60c55517ea841aa676d7e74259b7b3291a7d08dfec790ab7f9a3b2580d20bccae3f1781e0834350badd9bab72f9c350badd9bab72f9c350badd9bab72f9c
X-Originating-IP: 98.234.127.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Group,

		pdflush threads clean dirty pages

	  Under the past simple assumption that a greater number of
	  page daemon threads will have the TENDENCY to clean
	  the pages faster.

	Another assumption is that a server will have at least 2x / 4x the
	number of drives and memory, so allocating more pdflush() threads
	makes sense.

	Relying on a recent change, code base on whether the system is
	a desktop or a server, scale the number of pdthreads() which would
	result in the below code change.

	The suggestion is to double the MIN number of threads and set the
	MAX number to 4x.

	./mm/pdflush.c
	/* Scale for a server */
	#define MIN_PDFLUSH_THREADS 	4		/* 2x desktop value */
	#define MAX_PDFLUSH_THREADS 	32		/* 4x desktop value */


	/*
	 * secondary suggestion is to add a DEBUG type /var/log/system  
messages that
	 * will rate limit independent of desktop or server.
          */

	else if (nr_pdflush_threads == MAX_PDFLUSH_THREADS) {
		   /* optional PDFLUSH msg */
		   if (printk_ratelimit() {
	 		                            printk(KERN_INFO "MAX_PDFLUSH_THREADS  
Limited\n");
                    }
          }
	

	
