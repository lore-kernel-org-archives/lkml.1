Return-Path: <linux-kernel-owner+w=401wt.eu-S1161057AbXAZQ60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161057AbXAZQ60 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161064AbXAZQ6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:58:21 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:16896 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030893AbXAZQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:57:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=QCThHXsBrdpHky+hqvngHDc/vJVhSzLomF+u5BiVIttpKSzJ/dvXbc8L2wpDvxbG+7cRM3Wq7x96QOS0l0vxMEQNuCnMnVVsEIZXvSY/nSdi11cG/BFJZdcPeobIWjkIfCvc3zpFQU/msVzzWcUJ33Nu4vWXhCuIhpe5G8E6O9Q=
Message-ID: <45BA32E7.9060703@googlemail.com>
Date: Fri, 26 Jan 2007 17:57:11 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andrew Morton <akpm@osdl.org>
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

kernel/sched.c: In function 'init_sched_domain_sysctl':
kernel/sched.c:5465: error: too many arguments to function 'register_sysctl_table'
make[1]: *** [kernel/sched.o] Error 1
make: *** [kernel] Error 2

Possible fix

Regards,
Michal

--
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)

Signed-off-by: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>

--- linux-work-clean/kernel/sched.c	2007-01-26 16:47:55.000000000 +0100
+++ linux-work/kernel/sched.c	2007-01-26 17:51:23.000000000 +0100
@@ -5462,7 +5462,7 @@ static void init_sched_domain_sysctl(voi
 		entry->mode = 0755;
 		entry->child = sd_alloc_ctl_cpu_table(i);
 	}
-	sd_sysctl_header = register_sysctl_table(sd_ctl_root, 0);
+	sd_sysctl_header = register_sysctl_table(sd_ctl_root);
 }
 #else
 static void init_sched_domain_sysctl(void)
