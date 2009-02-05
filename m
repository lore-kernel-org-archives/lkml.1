Return-Path: <linux-kernel-owner+w=401wt.eu-S1756695AbZBENDQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756695AbZBENDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:03:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751936AbZBENC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:02:57 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56258 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbZBENC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:02:56 -0500
Subject: Re: Warning and BUG with btrfs and corrupted image
From: Chris Mason <chris.mason@oracle.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sesterhenn <snakebyte@gmx.de>,
       linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
In-Reply-To: <20090205090229.GA2011@elf.ucw.cz>
References: <20090120101119.GB10158@disturbed>
	 <20090120101503.GC17377@alice> <20090120125944.GC10158@disturbed>
	 <20090120132829.GA27429@infradead.org> <20090120222019.GB2320@elf.ucw.cz>
	 <20090121040042.GI10158@disturbed> <20090126162711.GA2083@elf.ucw.cz>
	 <20090201014050.GD24173@disturbed> <20090204182951.GC4797@elf.ucw.cz>
	 <20090205085916.GP24173@disturbed>  <20090205090229.GA2011@elf.ucw.cz>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 08:02:39 -0500
Message-Id: <1233838959.15948.6.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0201.498AE372.01F3:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-05 at 10:02 +0100, Pavel Machek wrote:
> > > > CONFIG_*_DEBUG means include *debug* code there to help developers,
> > > > including adding additional failure tests into the kernel. Besides,
> > > > which bit of "don't turn it on unless you are an XFS developer"
> > > > don't you understand?
> > > 
> > > Yes, but DEBUG code is normally to help debugging, not to crash
> > > kernels.
> > 
> > Crashing the kernel at exactly the point a problem is detected
> > is often the simplest way of debugging the problem.
> > 
> > e.g. CONFIG_VM_DEBUG=y turns on VM_BUG_ON() which crashes the kernel
> > whenever it detects something wrong. Do I turn it on? Yes. Do i
> 
> That's different. User is not supposed to be able to trigger
> VM_BUG_ON().
> 
> > complain about it when I hit a VM_BUG_ON()? No, I report the
> > bug and move on. If you turn on a DEBUG option, then you are
> > asking the system to behave in a way useful to a developer,
> > not an end user. That includes panicing when something wrong
> > is detected.
> 
> Imagine vm going panic() on mkdir("/lost+found")...

It is up to the XFS developers to decide what their debugging options
do.  

The whole point of panicing is so that you can collect important
information about the system at the time of the error condition.  When
this option is compiled on, panic on mkdir is exactly what they are
asking for.

If you don't want it, don't compile it in.  The Kconfig text is very
clear.

-chris


