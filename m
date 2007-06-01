Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbXFAWZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbXFAWZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 18:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXFAWZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 18:25:04 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753064AbXFAWZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 18:25:01 -0400
Date: Fri, 1 Jun 2007 15:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: menage@google.com, dev@sw.ru, xemul@sw.ru, vatsa@in.ibm.com,
       ebiederm@xmission.com, haveblue@us.ibm.com, svaidy@linux.vnet.ibm.com,
       balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 1/2][RFC] containers: improve automatic container naming
Message-Id: <20070601152334.b1452ed5.akpm@linux-foundation.org>
In-Reply-To: <20070601214809.GA20897@sergelap.austin.ibm.com>
References: <20070601214809.GA20897@sergelap.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007 16:48:09 -0500
"Serge E. Hallyn" <serue@us.ibm.com> wrote:

> This compiles and boots, but is not intended for inclusion in -mm (yet),
> just as an RFC for the naming scheme to fix the bug Andrew pointed out.
> 
> Seem ok overall?
> 
> thanks,
> -serge
> 
> >From 8e9b972f7482415777e982d3bc9a0d55cbaf862b Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Fri, 1 Jun 2007 15:32:15 -0400
> Subject: [PATCH 1/2] containers: improve automatic container naming
> 
> The automatic naming of containers created using container_clone()
> is currently broken (not protected from wraparound) and inconvenient.
> 
> Add a per-container counter for use in naming children of the container.
> Before two unshares in a row by one process, and a third in another,
> would result in
> 
> 	/node1/node2
> 	/node3
> 
> The current scheme should result in
> 
> 	/node1/node1
> 	/node2
> 
> Also, keep a hash table populated with used names, to protect
> against counter wrap-around.
> 
> ...
>
>  include/linux/container.h |    8 +++
>  kernel/container.c        |  116 +++++++++++++++++++++++++++++++++++++++++++--

gad, what's all this stuff?

I think an IDR tree would get you what you're after in much less code. 
Although it means that container IDs would get recycled quickly across a
remove+add.

Be aware that there are IDR enhancements in Greg's driver tree (and hence
in -mm) which are relevant to this application.


> +	if (cont->auto_cnt_set) {

Can we please stop using "cnt" and "cont" to refer to containers?  Let's
use "container", OK?


