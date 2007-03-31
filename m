Return-Path: <linux-kernel-owner+w=401wt.eu-S933539AbXCaDJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933539AbXCaDJH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 23:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933559AbXCaDJG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 23:09:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52617 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933539AbXCaDJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 23:09:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=n485XYCrmzvJsRexwWrncXaLJkl8ZkHXYmqLxmHdSs8DwXk5kVX1Go+tjPbY6kmPa8tdgUqUvhIwwkI1HR5iiPwdB8qW/hcfZqBD/RGyKeEq8H7R8gfoNMz5DoK2dZQHx41Fc/RL8zOH5cOZNoY9OoZA3typrUj2YiVtL3G1GsA=
Message-ID: <2375c9f90703302009i28f2f11ayf3e83216f4017c7d@mail.gmail.com>
Date: Sat, 31 Mar 2007 11:09:03 +0800
From: "Cong WANG" <xiyou.wangcong@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       jikos@jikos.cz, "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: fs/block_dev.c:953: warning: 'found' might be used uninitialized in this function
In-Reply-To: <20070330194701.GL14134@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200703281847.05356.toralf.foerster@gmx.de>
	 <75b66ecd0703280956i522cf6cbyc4c9ef8b1666ec15@mail.gmail.com>
	 <Pine.LNX.4.64.0703281909240.29565@twin.jikos.cz>
	 <20070328131454.cdb06bc3.akpm@linux-foundation.org>
	 <46C1CD24-F48E-4EB9-B6A5-E1B3C303C62F@mac.com>
	 <20070330194701.GL14134@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/3/31, Adrian Bunk <bunk@stusta.de>:
> On Thu, Mar 29, 2007 at 11:16:39PM -0400, Kyle Moffett wrote:
> > On Mar 28, 2007, at 16:14:54, Andrew Morton wrote:
> > >On Wed, 28 Mar 2007 19:23:32 +0200 (CEST)
> > >Jiri Kosina <jikos@jikos.cz> wrote:
> > >
> > >>blockdev: bd_claim_by_kobject() could check value of unititalized
> > >>pointer
> > >>
> > >>Fixes this warning:
> > >>
> > >>fs/block_dev.c: In function `bd_claim_by_kobject':
> > >>fs/block_dev.c:953: warning: 'found' might be used uninitialized
> > >>in this function
> > >>
> > >>struct bd_holder *found is initialized only when bd_claim()
> > >>returns zero. If it returns nonzero, ptr stays uninitialized.
> > >>Later the value of the pointer is checked.
> > >
> > >that generates extra code and people get upset.
> > >
> > >One approach which we could ue in here is
> > >
> > >     struct bd_holder *found = found;  /* Suppress bogus gcc warning */
> >
> > Well, that would be correct except the warning is an actual kernel
> > bug.  Read Jiri's message (which you also quoted):
> > >struct bd_holder *found is initialized only when bd_claim() returns
> > >zero. If it returns nonzero, ptr stays uninitialized. Later the
> > >value of the pointer is checked.
> >
> > So in this case it has to be initialized to NULL or there's a
> > potential BUG() lurking.
>
>
> No, the code is correct and it's impossible that the variable ever gets
> read uninitialized.
>
> And BTW, i386 gcc 4.1 doesn't give me a warning for this.
> Toralf, which gcc version and architecture did you see this with?
>

I am also using i386 gcc 4.1.1, and I did receive many warnings of
such kind yesterday. I think we should fix them.

And the reason for the existence of such things is we just want to use
them for writing first instead of reading, thus ignore the
initialization.

-- 
So Dark The Con Of Man.
