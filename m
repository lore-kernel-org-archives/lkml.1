Return-Path: <linux-kernel-owner+w=401wt.eu-S1161092AbXAZRsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161092AbXAZRsx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161093AbXAZRsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:48:53 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:22841 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161092AbXAZRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:48:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=sqOIm3TYd/N6c+WtwJI2DLRT+i1dPPlotiNZCQLMmYkawftxxxyEzygJNX429wbDrB5Kh7qf79tD2z7o7rwXTZo017mbYabvfl1yaC9zm30cmfLPTW5ZlQQptBv2X/YMcUAW9swHY9+H9lBaVsutHb2dc3RrdsWYi4tasq7AmNI=
Message-ID: <45BA3EF3.2070309@googlemail.com>
Date: Fri, 26 Jan 2007 18:48:35 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>, Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
In-Reply-To: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

akpm@osdl.org napisa³(a):
> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded to
> 
>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 

kernel/sys.c:359: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here
kernel/sys.c:375: error: conflicting types for '__blocking_notifier_call_chain'
include/linux/notifier.h:140: error: previous declaration of '__blocking_notifier_call_chain' was here
make[1]: *** [kernel/sys.o] Error 1
make: *** [kernel] Error 2

Possible fix.

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/kernel/sys.c	2007-01-26 16:47:56.000000000 +0100
+++ linux-work/kernel/sys.c	2007-01-26 18:40:30.000000000 +0100
@@ -355,7 +355,7 @@ EXPORT_SYMBOL_GPL(blocking_notifier_chai

 int __blocking_notifier_call_chain(struct blocking_notifier_head *nh,
 				   unsigned long val, void *v,
-				   int nr_to_call, unsigned int *nr_calls)
+				   int nr_to_call, int *nr_calls)
 {
 	int ret = NOTIFY_DONE;



