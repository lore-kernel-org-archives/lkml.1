Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbZLDJ2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbZLDJ2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:28:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754461AbZLDJ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:28:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182AbZLDJ2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:28:49 -0500
Subject: Re: + task_struct-make-journal_info-conditional.patch added to -mm
 tree
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       chris.mason@oracle.com, konishi.ryusuke@lab.ntt.co.jp, tytso@mit.edu
In-Reply-To: <20091204051729.GA3927@x200>
References: <200912032240.nB3Mevae027408@imap1.linux-foundation.org>
	 <20091204021444.GA8392@x200> <4B1888CE.8000406@ct.jp.nec.com>
	 <20091204051729.GA3927@x200>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 04 Dec 2009 09:31:06 +0000
Message-Id: <1259919066.2489.2.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2009-12-04 at 08:17 +0300, Alexey Dobriyan wrote:
> On Fri, Dec 04, 2009 at 12:58:06PM +0900, Hiroshi Shimamoto wrote:
> > Alexey Dobriyan wrote:
> > > On Thu, Dec 03, 2009 at 02:40:57PM -0800, akpm@linux-foundation.org wrote:
> > >> --- a/include/linux/sched.h~task_struct-make-journal_info-conditional
> > >> +++ a/include/linux/sched.h
> > >> @@ -1452,8 +1452,10 @@ struct task_struct {
> > >>  	gfp_t lockdep_reclaim_gfp;
> > >>  #endif
> > >>  
> > >> +#ifdef CONFIG_FS_JOURNAL_INFO
> > >>  /* journalling filesystem info */
> > >>  	void *journal_info;
> > >> +#endif
> > > 
> > > This will prevent using e.g. ext3 on CONFIG_EXT3_FS=n kernels.
> > 
> > I'm sorry, I'm not sure what you're mentioning.
> 
> With this patch admin must decide in advance if he will ever use ext3.
> EXT3_FS=n kernels won't be able to get ext3 support without reboot
> even as module, because task_struct will be different.
> 
> Which is a regression compared to current state.
> 
> The biggest example of such behaviour is ipv6 module, but it should not
> be spread more.

I agree. If we want to be rid of this then I think we should simply pass
the journal info as a parameter through the relevant filesystems (is
there any reason why we do things this way? I couldn't think of one) and
thus avoid the use of this field in the first place,

Steve.


