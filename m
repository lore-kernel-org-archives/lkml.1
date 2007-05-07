Return-Path: <linux-kernel-owner+w=401wt.eu-S966897AbXEGWR7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966897AbXEGWR7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 18:17:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966583AbXEGWR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 18:17:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46826 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966557AbXEGWR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 18:17:57 -0400
Message-ID: <463FA506.3070207@redhat.com>
Date: Mon, 07 May 2007 17:15:34 -0500
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: sam@ravnborg.org, kbuid-devel@lists.sourceforge.net
Subject: Re: [PATCH] [KBUILD] fix external module install path
References: <463F9C3B.4080004@sandeen.net> <463F9DFF.7010101@redhat.com>
In-Reply-To: <463F9DFF.7010101@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Sandeen wrote:
> Eric Sandeen wrote:
>> Installing external modules is supposed to put them in some path
>> under /lib/modules/<version>/extra/subdir/, but this change:
>> http://linux.bkbits.net:8080/linux-2.6/?PAGE=cset&REV=1.1982.9.23
>> makes them go under /lib/modules/<version>/extrasubdir
> 
> er, hang on.  Now it's not doing it ;-)  stay tuned.
> 
> Sorry... I really did get an "extrafs/" directory somehow :)

Urgh, I can't figure out what tickles it reliably.

There is at least another buglet (?) though, if you don't put a slash on
the end of your M=, you lose the subdir path.

[root@marathon-01 linux-2.6.18.x86_64]# make M=fs/ext3/ modules_install
  INSTALL fs/ext3/ext3.ko
  DEPMOD  2.6.18-8.el5
[root@marathon-01 linux-2.6.18.x86_64]# find /lib/modules/`uname
-r`/extra* -name ext3.ko
/lib/modules/2.6.18-8.el5/extra/fs/ext3/ext3.ko

[root@marathon-01 linux-2.6.18.x86_64]# make M=fs/ext3 modules_install
  INSTALL fs/ext3/ext3.ko
  DEPMOD  2.6.18-8.el5
[root@marathon-01 linux-2.6.18.x86_64]# find /lib/modules/`uname
-r`/extra* -name ext3.ko
/lib/modules/2.6.18-8.el5/extra/fs/ext3/ext3.ko
/lib/modules/2.6.18-8.el5/extra/ext3.ko

I'm confused.  Maybe Sam knows how to fix it... :)

-Eric
