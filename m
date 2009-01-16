Return-Path: <linux-kernel-owner+w=401wt.eu-S932180AbZAPJqF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbZAPJqF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 04:46:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762785AbZAPJpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 04:45:41 -0500
Received: from casper.infradead.org ([85.118.1.10]:33258 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbZAPJpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 04:45:39 -0500
Subject: Re: generic swap()
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <wfg@linux.intel.com>, L-K <linux-kernel@vger.kernel.org>
In-Reply-To: <20090116013834.539c692e.akpm@linux-foundation.org>
References: <1232097994.14073.4.camel@laptop>
	 <20090116013834.539c692e.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 10:45:36 +0100
Message-Id: <1232099136.14073.9.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-16 at 01:38 -0800, Andrew Morton wrote:
> On Fri, 16 Jan 2009 10:26:34 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Hi,
> > 
> > Where did this patch come from? -- I can't seem to find it on lkml at all..
> 
> That's a damn good question.  I received:

Hehe, one of the mysteries of life then :-)

> > The reason I ask it that I wonder why swap() has a return value?
> 
> Accident, I guess.
> 
> > +#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
> 
> You think it should use the do{}while(0) thing?

That was what I was thinking indeed. Non of the current users appear to
make use of the (somewhat arbitrary) return value, so lets change it
before someone gets creative ;-)

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 343df9e..7fa3718 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -480,7 +480,8 @@ static inline char *pack_hex_byte(char *buf, u8 byte)
 /*
  * swap - swap value of @a and @b
  */
-#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 /**
  * container_of - cast a member of a structure out to the containing structure


