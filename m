Return-Path: <linux-kernel-owner+w=401wt.eu-S1758502AbYFJTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758502AbYFJTQj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 15:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756762AbYFJTPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 15:15:51 -0400
Received: from mu-out-0910.google.com ([209.85.134.189]:26336 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756278AbYFJTPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 15:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=AfIYAtjZf5hF0gWiAMANZbaA5fO//j//oxoBWIMIadG9kLVV5S2I5C5LbBvvD7e3na
         FTeZ/GLA5I/e09+hCcsoVZPCpKuDFeG9gzVPsydzwQw2vTuxdDtNLM6jPy+itQqy1qeJ
         BtrUCVQhyNIO6l3rBgJg0Dvnmv1QP+XWYw/Zo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] fix BLK_DEV_HD_ONLY on ARM dependencies
Date: Tue, 10 Jun 2008 19:56:15 +0200
User-Agent: KMail/1.9.9
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk
References: <20080609222155.GA1987@cs181133002.pp.htv.fi>
In-Reply-To: <20080609222155.GA1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200806101956.15711.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 June 2008, Adrian Bunk wrote:
> This patch limits BLK_DEV_HD_ONLY to the ARM platforms offering 
> IRQ_HARDDISK, fixing the following compile error on others:
> 
> <--  snip  -->
> 
> ...
>   CC      drivers/ide/legacy/hd.o
> ...
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_times_out':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: (Each undeclared identifier is reported only once
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:542: error: for each function it appears in.)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'do_hd_request':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:661: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c: In function 'hd_init':
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/ide/legacy/hd.c:765: error: 'IRQ_HARDDISK' undeclared (first use in this function)
> make[3]: *** [drivers/ide/legacy/hd.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

applied, thanks

BTW Could you look into converting your "remove BLK_DEV_HD_ONLY" patch
into "move old hd driver to drivers/block/" one because the old hd driver
still has some uses (as noticed by Alan)?
