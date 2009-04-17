Return-Path: <linux-kernel-owner+w=401wt.eu-S1757869AbZDQN3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757869AbZDQN3a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 09:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754205AbZDQN3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 09:29:22 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43695 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbZDQN3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:29:21 -0400
In-Reply-To: <15909.1239887985@jrobl>
References: <15909.1239887985@jrobl>
To: hooanon05@yahoo.co.jp
Cc: linux-kernel@vger.kernel.org, david safford <safford@watson.ibm.com>
MIME-Version: 1.0
Subject: Re: IMA and fs
X-KeepSent: 1283DDC6:0AD2926E-8525759B:004938DD;
 type=4; name=$KeepSent
X-Mailer: Lotus Notes Release 8.5 December 05, 2008
Message-ID: <OF1283DDC6.0AD2926E-ON8525759B.004938DD-8525759B.004A1887@us.ibm.com>
From: Mimi Zohar <zohar@us.ibm.com>
Date: Fri, 17 Apr 2009 09:29:19 -0400
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 04/17/2009 09:29:19,
	Serialize complete at 04/17/2009 09:29:19
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hooanon05@yahoo.co.jp wrote on 04/16/2009 09:19:45 AM:

> I have found (at least) two issues about IMA.
> 
> 1.
> Calling stack
> - kmem_cache_alloc(iint_cache, GFP_KERNEL)
> - ima_inode_alloc()
> - inode_init_always()
> - xfs_iget_cache_hit()
> - xfs_iget()
> 
> xfs_iget() holds spinlock before xfs_iget_cache_hit(), and
> ima_inode_alloc() cannot use GFP_KERNEL.

This looks similar to the xfs - IMA problem discussed
http://lkml.org/lkml/2009/2/20/327.
 
> 2.
> ima_path_check() seems to be necessary before every opening a file.
> In 2.6.30-rc1, IMA produces lots of messages and stack trace when NFSD
> opens a file. 
> Does nfsd_open() need to to call ima_path_check()?
> 
> 
> J. R. Okajima

Yes, in order for the open/free to be balanced in ima_file_free().

Mimi Zohar
