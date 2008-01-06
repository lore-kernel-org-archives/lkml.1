Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbYAFTHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbYAFTHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 14:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752209AbYAFTHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 14:07:15 -0500
Received: from smtprelay09.ispgateway.de ([80.67.29.23]:44068 "EHLO
	smtprelay09.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYAFTHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 14:07:14 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Jan 2008 14:07:13 EST
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Bernd Schubert <bernd-schubert@gmx.de>
Subject: Re: sleep before boot panic
Date: Sun, 6 Jan 2008 20:01:14 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <200801061908.43010.bernd-schubert@gmx.de>
In-Reply-To: <200801061908.43010.bernd-schubert@gmx.de>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062001.15220.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

On Sunday 06 January 2008, you wrote:
> Index: zd1211rw.git.beno/init/do_mounts.c
> ===================================================================
> --- zd1211rw.git.beno.orig/init/do_mounts.c	2008-01-06 18:44:23.000000000 
> +0100
> +++ zd1211rw.git.beno/init/do_mounts.c	2008-01-06 18:45:44.000000000 +0100
> @@ -330,6 +330,7 @@
>  		printk("Please append a correct \"root=\" boot option; here are the 
> available partitions:\n");
>  
>  		printk_all_partitions();
> +		msleep(60 * 1000);

ssleep(60);

>  		panic("VFS: Unable to mount root fs on %s", b);
>  	}

Better would be for this and similiar panic()s
(fatal user/admin errors on boot) to NOT print a stack trace+registers,
since it is useless and actually hides useful information.


Best Regards

Ingo Oeser
