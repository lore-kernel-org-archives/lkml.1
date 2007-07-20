Return-Path: <linux-kernel-owner+w=401wt.eu-S939404AbXGTXoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939404AbXGTXoZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933668AbXGTXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:44:04 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765468AbXGTXoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:44:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sebastian Siewior <sebastian@breakpoint.cc>
Subject: Re: [PATCH] compat_ioctl requires CONFIG_BLOCK
Date: Sat, 21 Jul 2007 01:08:57 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <20070720225817.050195257@ayoka.breakpoint.cc>
In-Reply-To: <20070720225817.050195257@ayoka.breakpoint.cc>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200707210108.58478.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+9jUFqmPkrMH2H31vfE4SQpPz2xgr0iyaqazt
 KeNkEAVC1g+OYu4jKmEaJgFJUxsLwqaLDdYoL3eJvFkcr4NWoP
 jZ3peKY3WSyBMcng2TY1g==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007, Sebastian Siewior wrote:
> 
> Got with randconfig
> include/linux/loop.h:66: error: expected specifier-qualifier-list before
> 'request_queue_t'
> make[1]: *** [fs/compat_ioctl.o] Error 1
> 
> parts of compat ioctl require CONFIG_BLOCK to be set.
> 
> Signed-off-by: Sebastian Siewior <sebastian@breakpoint.cc>
> Index: b/fs/compat_ioctl.c
> ===================================================================
> --- a/fs/compat_ioctl.c
> +++ b/fs/compat_ioctl.c
> @@ -63,7 +63,9 @@
>  #include <linux/wireless.h>
>  #include <linux/atalk.h>
>  #include <linux/blktrace_api.h>
> +#ifdef CONFIG_BLOCK
>  #include <linux/loop.h>
> +#endif

Adding #ifdef around an #include is considered bad style. Better just
make loop.h compile without any conditionals. Does the below
patch work for you?

	Arnd <><

--- a/include/linux/loop.h
+++ b/include/linux/loop.h
@@ -63,7 +63,7 @@ struct loop_device {
 	struct task_struct	*lo_thread;
 	wait_queue_head_t	lo_event;
 
-	request_queue_t		*lo_queue;
+	struct request_queue	*lo_queue;
 	struct gendisk		*lo_disk;
 	struct list_head	lo_list;
 };
