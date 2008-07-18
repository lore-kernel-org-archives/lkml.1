Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbYGRNIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbYGRNIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 09:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755807AbYGRNIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 09:08:04 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:47713 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbYGRNIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 09:08:01 -0400
Date: Fri, 18 Jul 2008 18:37:51 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Shehjar Tikoo <shehjart@cse.unsw.edu.au>, Mingming Cao <cmm@us.ibm.com>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: ext4 fallocate related crash on 2.6.26
Message-ID: <20080718130751.GA25771@skywalker>
References: <487C223D.6060704@cse.unsw.edu.au> <20080718120024.GA23898@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718120024.GA23898@skywalker>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 05:30:24PM +0530, Aneesh Kumar K.V wrote:
> On Tue, Jul 15, 2008 at 02:06:21PM +1000, Shehjar Tikoo wrote:
> > Hi all
> >
> > I've observed the following kernel crash during tests against ext4  
> > fallocate'ion support on 2.6.26.
> >
> > Stack trace is at:
> > http://www.gelato.unsw.edu.au/~shehjart/docs/ext4_fallocate_test_trace_2.6.26.txt
> >
> > The test involved running the following program which fallocates a given 
> > length in bytes then writes to it. The above crash was seen when writing 
> > to an ext4 disk, 2G file, in blocks of 64k with fallocate requests of 
> > 1mb. After each 1mb of data is written to the fallocated space, another 
> > 1mb is requested. This write-fallocate cycle continues till the requested 
> > file size is reached. The trace is from one of the crashes from the 
> > various runs(all crashed). I must emphasise that after one of the runs, 
> > the test disk could not be mounted as the filesystem was unrecognized. 
> > ext4dev was mounted in data=ordered mode.
> >
> > See the test code at:
> > http://www.gelato.unsw.edu.au/~shehjart/docs/writefallocate.c
> >
> > The command line arguments are self-explanatory. Run without any  
> > arguments to see the usage message. Do change the _NR_fallocate define  
> > at the beginning of the file to your architecture's syscall number for  
> > sys_fallocate.
> >
> > I can run a few more tests if more info is needed.
> 
> 
> Can you try this patch ?
> 

I tested this on powerpc and x86 where i was able to reproduce the
problem earlier. With the fix the test runs fine.

-aneesh
