Return-Path: <linux-kernel-owner+w=401wt.eu-S1751276AbZLDFRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751276AbZLDFRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 00:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZLDFRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 00:17:32 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60126 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823AbZLDFRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 00:17:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PJV0hEga3hA0j9ynWNTYksNlUrQE+wppAFLb2Hs8/72KWbu2mF6hSLwSINV5eOb7zp
         BEduniOxhHYLA75VKzBHbDM95u+nQbhLLDj5gc3CawH5N1tIxiEe1rr2c24iV/6rlJH/
         WmF+f0tsFhq2Z3A4dnbV5yvKRYfChxoEMBbqo=
Date: Fri, 4 Dec 2009 08:17:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp,
       swhiteho@redhat.com, tytso@mit.edu
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
Message-ID: <20091204051729.GA3927@x200>
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
 <20091204021444.GA8392@x200>
 <4B1888CE.8000406@ct.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1888CE.8000406@ct.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 04, 2009 at 12:58:06PM +0900, Hiroshi Shimamoto wrote:
> Alexey Dobriyan wrote:
> > On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
> >> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
> >> +++ a/include/linux/sched.h
> >> @@ -1452,8 +1452,10 @@ struct task_struct {
> >>  	gfp_t lockdep_reclaim_gfp;
> >>  #endif
> >>  
> >> +#ifdef CONFIG_FS_JOURNAL_INFO
> >>  /* journalling filesystem info */
> >>  	void *journal_info;
> >> +#endif
> > 
> > This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
> 
> I'm sorry, I'm not sure what you're mentioning.

With this patch admin must decide in advance if he will ever use ext3.
EXT3_FS=n kernels won't be able to get ext3 support without reboot
even as module, because task_struct will be different.

Which is a regression compared to current state.

The biggest example of such behaviour is ipv6 module, but it should not
be spread more.
