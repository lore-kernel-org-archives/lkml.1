Return-Path: <linux-kernel-owner+w=401wt.eu-S1761443AbXEPPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761443AbXEPPeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 11:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756591AbXEPPeZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 11:34:25 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57134 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754723AbXEPPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 11:34:24 -0400
Date: Wed, 16 May 2007 08:29:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <htejun@gmail.com>
Cc: Clemens Schwaighofer <cs@tequila.co.jp>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Maneesh Soni <maneesh@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Greg KH <greg@kroah.com>
Subject: Re: Oops and Panics in 2.6.21.1, 2.6.20.6 and 2.6.19.2
Message-Id: <20070516082935.fe112ab5.akpm@linux-foundation.org>
In-Reply-To: <464AE56F.3040101@gmail.com>
References: <464A4F56.6080108@tequila.co.jp>
	<20070515185350.2e77bf21.akpm@linux-foundation.org>
	<464AE56F.3040101@gmail.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 13:05:19 +0200 Tejun Heo <htejun@gmail.com> wrote:

> Hello,
> 
> Andrew Morton wrote:
> > On Wed, 16 May 2007 09:24:54 +0900 Clemens Schwaighofer <cs@tequila.co.jp> wrote:
> > 
> >> I have re-occurring oopses and panics in those above kernels. The error
> >> is always the same. I have the last Kernel Panic as a picture here:
> >>
> >> http://dev.tequila.jp/clemens/R0010172.JPG
> >>
> >> The oops have the same error style like this Panic. I tried to capture
> >> one, but right after copying it into vim, I got a Panic. So next time I
> >> try to.
> >>
> >> I think it started with 2.6.19.2, I cannot remember I had any of those
> >> problems before. The box can work fine for about a week or more, or it
> >> looks up several times a day. I run a memtest for 10 h, but I had no errors.
> > 
> > shrink_dcache_memory->...sysfs_d_iput->BUG
> > 
> >                 BUG_ON(sd->s_dentry != dentry);
> > 
> > a number of people have hit that, on and off.
> 
> Yeah, I've been seeing that one.  It should have been fixed with the big
> fat patchset.

Great - fingers crossed.

> > We were close to having a fix, I think, but then we decided that great
> > chunks of sysfs needed rewriting and I believe that we believe that this
> > great rewrite will fix this bug.
> 
> How were we gonna fix it?  If it isn't too complex, I can cook up a
> patch for -stable series.

Do we actually understand the causes?

>  The safest approach I can think of is making
> dentries for attributes unreclaimable but those are made reclaimable for
> good reasons.  :-(

Yeah, that was the google workaround.  It's OK unless you happen to have
thousands of disks on an ia32 box.

