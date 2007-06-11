Return-Path: <linux-kernel-owner+w=401wt.eu-S1756226AbXFKQAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbXFKQAA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 12:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbXFKP7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 11:59:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:45660 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752229AbXFKP7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 11:59:49 -0400
X-Authenticated: #19095397
X-Provags-ID: V01U2FsdGVkX19fimxVeRVfNp1I4SJSon3gdRF6vHeuoYj8xDzbhO
	0ntni9zUPSpTii
From: Bernd Schubert <bernd-schubert@gmx.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: API changes / 2.6.21 sysctl changes
Date: Mon, 11 Jun 2007 17:59:45 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <200706111513.12998.bernd-schubert@gmx.de> <20070611154627.GA5715@martell.zuzino.mipt.ru>
In-Reply-To: <20070611154627.GA5715@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706111759.45774.bernd-schubert@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 June 2007 17:46:27 Alexey Dobriyan wrote:
> On Mon, Jun 11, 2007 at 03:13:12PM +0200, Bernd Schubert wrote:
> > in 2.6.21 register_sysctl_table(), struct ctl_table and probably
> > something else did change. Unfortunately so far I didn't figure out the
> > "something else".
>
> Do you have a problem porting your sysctls to newer kernels?

A little bit, yes. Well, I got it working, but I don't understand why I had to 
do that whay.

I'm porting lustre to newer kernel versions and up to 2.6.20 the procfs/sysctl 
logic was 

1.) register_sysctl_table() -> creates /proc/sys/lnet

2.) create_proc_entry()  -> add additional files in /proc/sys/lnet 

With 2.6.21 creating additional entries in /proc/sys/lnet fails and I have to 
first call "proc_mkdir("sys/lnet", NULL)". I did this proc_mkdir() call even 
before the register_sysctl_table() call, hoping that its correct.

My guess is that register_sysctl_table() doesn't create /proc/sys/lnet 
anymore, but I have now idea why. Either I did something wrong or its 
intended. 

Since I don't like guessing I ask for more documentation. However I think in 
general, each interface change should be documented. Its just such a waste of 
time of many people, just because one person doesn't want to spend additional 
5 min to write what did change.

Thanks
