Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbXGJNIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbXGJNIz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbXGJNIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:08:48 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:9103 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752633AbXGJNIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:08:47 -0400
Message-ID: <46938440.7000301@openvz.org>
Date: Tue, 10 Jul 2007 17:06:08 +0400
From: Pavel Emelianov <xemul@openvz.org>
User-Agent: Thunderbird 1.5 (X11/20060317)
MIME-Version: 1.0
To: Badari Pulavarty <pbadari@gmail.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Cedric Le Goater <clg@fr.ibm.com>
CC: Kirill Korotaev <dev@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [PATCH 0/16] Pid namespaces
References: <468DF6F7.1010906@openvz.org> <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
In-Reply-To: <1184003180.21234.39.camel@dyn9047017100.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Not able to boot my ppc64 machine with the patchset :(
> 
> Thanks,
> Badari

That's the hunk lost during the split:

--- ./fs/proc/root.c.procfix	2007-07-10 13:52:08.000000000 +0400
+++ ./fs/proc/root.c	2007-07-10 15:23:20.000000000 +0400
@@ -111,7 +111,7 @@ void __init proc_root_init(void)
 	err = register_filesystem(&proc_fs_type);
 	if (err)
 		return;
-	proc_mnt = kern_mount(&proc_fs_type);
+	proc_mnt = kern_mount_data(&proc_fs_type, &init_pid_ns);
 	err = PTR_ERR(proc_mnt);
 	if (IS_ERR(proc_mnt)) {
 		unregister_filesystem(&proc_fs_type);


With this machine should boot fine.

Thanks,
Pavel
