Return-Path: <linux-kernel-owner+w=401wt.eu-S1759881AbZANVZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759881AbZANVZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 16:25:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756260AbZANVY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 16:24:56 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:32159 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbZANVYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 16:24:55 -0500
Subject: Re: [linux-dvb] compiling on 2.6.28 broken?
From: Chris Mason <chris.mason@oracle.com>
To: wk <handygewinnspiel@gmx.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, HWerner4@gmx.de, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       mchehab@infradead.org
In-Reply-To: <496E56EB.2030301@gmx.de>
References: <20090112190420.51f75853@pedra.chehab.org>
	 <20090112132130.6c932b85.akpm@linux-foundation.org>
	 <20090112220624.4fbfee34@pedra.chehab.org>
	 <20090112162337.318dd61d.akpm@linux-foundation.org>
	 <20090113184755.87720@gmx.net>
	 <20090113105947.9e774b69.akpm@linux-foundation.org>
	 <20090113191757.74290@gmx.net>
	 <20090113113700.776a94b5.akpm@linux-foundation.org>
	 <20090113203843.GJ29283@parisc-linux.org>
	 <1231957750.8269.28.camel@think.oraclecorp.com>  <496E56EB.2030301@gmx.de>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 16:24:00 -0500
Message-Id: <1231968240.8269.48.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.496E57F6.02E9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 22:19 +0100, wk wrote:
> Chris Mason wrote:
> > On Tue, 2009-01-13 at 13:38 -0700, Matthew Wilcox wrote:
> >   
> >> On Tue, Jan 13, 2009 at 11:37:00AM -0800, Andrew Morton wrote:
> >>     
> >>> I'd have expected to see stat() returning -EOVERFLOW, but it isn't there.
> >>>
> >>> googling around a bit seems to indcate that this might be a glibc issue:
> >>>
> >>> http://sourceware.org/bugzilla/show_bug.cgi?id=1864
> >>> http://bugs.gentoo.org/show_bug.cgi?id=146951
> >>>
> >>> But the traces are all using stat64() and fstat64().  And why would it
> >>> just start occurring now?
> >>>       
> >> Maybe glibc is using the 64-bit stat calls and returning -EOVERFLOW to
> >> the application when the results from the kernel turn out to be > 32-bit
> >> in size?
> >>
> >>     
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6c31b93a14a453c8756ffd228e24910ffdf30c5d
> >
> > I'd guess the commit above is related, although I don't see any way for
> > it to make things interesting without the user doing mount -o inode64.
> >
> > strace -v should show us more, it would show if the inode numbers coming
> > out of stat64 are big.
> >
> > -chris
> >
> >   
> I cannot fully understand what strace -v outputs (see attachment), but 
> what i see is that 'find' stops after finding a file with d_off = 4294967295
> 4294967295  =  0xFFFFFFFF, adding any number greater that zero will be 
> greater that 32bits, so this could be the reason for the message "value 
> too large".
> 
> 
> 
> I also noticed that i cannot access these files through samba if i boot 
> from 2.6.28 - really strange.
> If i reboot older kernels these are visible in samba again and fully 
> accessible.
> 
> Attached the log from stracing the command which was ivoked by the 
> Makefile from v4l-dvb.
> I guess this is all i could contribute to that problem. Thats stuff for 
> xfs filesystem experts now..

Seems suspect indeed.  Could you please attach the strace for the run
that works on the older kernel?

-chris


