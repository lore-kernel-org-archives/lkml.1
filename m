Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbXIGW5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbXIGW5f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 18:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXIGW52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 18:57:28 -0400
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:28678 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750791AbXIGW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 18:57:27 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Message-Id:Content-Type;
  b=5ZOtnD51tjI2VMz/inOa2r+oALurHWeIo0LKbQpzkSooa0/C4SvaFhOSWb1/JU/JOQGDe8yscFw7k4F9lNn2rX5lkmvRwVTW6TmQDmkC7hhmhf+q3r9U2mx6JqRE9XYWPweXRLGj9ORUIy8+SuKP3MwWUokibfEW4z8XZdBG3WY=  ;
X-YMail-OSG: 53yFoOgVM1k.8El664bPvRmFbB3YIo34T1WjMx4ovJKsM.xPotsswkQAXlvQnVuznitpP56WR6Z8o6anAF28DaRfEJBzBeBKT1TUsC7TASypcknNz1NzoeMNouCbIQ--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Jesse Barnes <jesse.barnes@intel.com>
Subject: Re: Intel Memory Ordering White Paper
Date: Sat, 8 Sep 2007 18:54:57 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200709071526.51169.jesse.barnes@intel.com>
In-Reply-To: <200709071526.51169.jesse.barnes@intel.com>
MIME-Version: 1.0
Message-Id: <200709081854.57549.nickpiggin@yahoo.com.au>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hNm4GagXemJf0LI"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_hNm4GagXemJf0LI
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 08 September 2007 08:26, Jesse Barnes wrote:
> FYI, we just released a new white paper describing memory ordering for
> Intel processors:
> http://developer.intel.com/products/processor/manuals/index.htm
>
> Should help answer some questions about some of the ordering primitives
> we use on i386 and x86_64.

So, can we finally noop smp_rmb and smp_wmb on x86?

--Boundary-00=_hNm4GagXemJf0LI
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="x86-barrier-opt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="x86-barrier-opt.patch"

Index: linux-2.6/include/asm-i386/system.h
===================================================================
--- linux-2.6.orig/include/asm-i386/system.h
+++ linux-2.6/include/asm-i386/system.h
@@ -286,7 +286,7 @@ static inline unsigned long get_limit(un
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
-#define smp_rmb()	rmb()
+#define smp_rmb()	barrier()
 #define smp_wmb()	wmb()
 #define smp_read_barrier_depends()	read_barrier_depends()
 #define set_mb(var, value) do { (void) xchg(&var, value); } while (0)
Index: linux-2.6/include/asm-x86_64/system.h
===================================================================
--- linux-2.6.orig/include/asm-x86_64/system.h
+++ linux-2.6/include/asm-x86_64/system.h
@@ -141,8 +141,8 @@ static inline void write_cr8(unsigned lo
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
-#define smp_rmb()	rmb()
-#define smp_wmb()	wmb()
+#define smp_rmb()	barrier()
+#define smp_wmb()	barrier()
 #define smp_read_barrier_depends()	do {} while(0)
 #else
 #define smp_mb()	barrier()

--Boundary-00=_hNm4GagXemJf0LI--
