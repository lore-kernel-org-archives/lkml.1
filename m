Return-Path: <linux-kernel-owner+w=401wt.eu-S1760487AbXJLMYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760487AbXJLMYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 08:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbXJLMYh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 08:24:37 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:33743 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbXJLMYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 08:24:36 -0400
Message-ID: <470F68EC.6040809@bull.net>
Date: Fri, 12 Oct 2007 14:30:36 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: what is the rationale for "TAINT_USER"?
References: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0710120801380.20049@localhost.localdomain>
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/10/2007 14:30:54,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 12/10/2007 14:30:55,
	Serialize complete at 12/10/2007 14:30:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=us-ascii; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
>   i can see what the theoretical purpose for it is here:
> 
> http://kerneltrap.org/node/6656
> 
> but it's not clear how it can possibly be set from userland given
> that:
> 
> $ grep -r TAINT_USER *
> include/linux/kernel.h:#define TAINT_USER                       (1<<6)
> kernel/panic.c:                 tainted & TAINT_USER ? 'U' : ' ',
> $
> 
>   am i missing something screamingly obvious?
> 
> rday

#ifdef CONFIG_PROC_SYSCTL
         {
                 .ctl_name       = KERN_TAINTED,
                 .procname       = "tainted",
                 .data           = &tainted,
                 .maxlen         = sizeof(int),
                 .mode           = 0644,
                 .proc_handler   = &proc_dointvec_taint,
         },
#endif


Regards,
Nadia
