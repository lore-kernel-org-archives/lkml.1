Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab0BPTSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 14:18:33 -0500
Received: from nwd2mail10.analog.com ([137.71.25.55]:5882 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab0BPTSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 14:18:32 -0500
X-IronPort-AV: E=Sophos;i="4.49,485,1262581200"; 
   d="scan'208";a="11750381"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Analog Devices, Inc.
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [RFC] Staging: IIO: New ABI V2
Date: Tue, 16 Feb 2010 14:18:27 -0500
User-Agent: KMail/1.9.5
CC: Greg KH <gregkh@suse.de>, Mike Frysinger <vapier.adi@gmail.com>,
       Kay Sievers <kay.sievers@vrfy.org>, LKML <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>,
       Manuel Stahl <manuel.stahl@iis.fraunhofer.de>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Trisal, Kalhan" <kalhan.trisal@intel.com>,
       "Zhang, Xing Z" <xing.z.zhang@intel.com>,
       Ira Snyder <iws@ovro.caltech.edu>, Jean Delvare <khali@linux-fr.org>,
       Samu Onkalo <samu.p.onkalo@nokia.com>,
       Stefani Seibold <stefani@seibold.net>
References: <4B6C619C.3000302@cam.ac.uk> <20100216024924.GA29008@suse.de> <4B7A7B8F.9080501@cam.ac.uk>
In-Reply-To: <4B7A7B8F.9080501@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201002161418.28097.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16 Feb 2010 06:03, Jonathan Cameron pondered:
> On 02/16/10 02:49, Greg KH wrote:
> > On Mon, Feb 15, 2010 at 07:58:12PM -0500, Mike Frysinger wrote:
> >> On Mon, Feb 15, 2010 at 15:26, Robin Getz wrote:
> >>> [snip]
> >>> What exists today still requires a copy_[to|from]_user when using
> >>> the ring buffer (and then another cache_flush if you are dma'ing
> >>> things). These seems pretty expensive and will consume extra cycles
> >>> that will limit throughput. 
> >>>
> >>> Any thoughts to a mmaped interface directly to the IIO ring buffer, 
> >>> so the system could avoid some of the above overhead? (This is what
> >>> we had to do for some other drivers - which were able to handle a 40
> >>> MSample/second data processed by userspace for a soft radio).
> >>
> >> does sysfs currently support mmap-ing of files in there ?
> > 
> > For binary files, yes.  If you are going to use mmap, use a character
> > device node instead please, that's not what sysfs is for.
> All the buffer access is done via character device nodes anyway.
> 
> For anyone entering the discussion at this point:
> Only really simple IIO drivers (for typically very slow devices)
> are principally accessed through sysfs.  For these fast devices we
> probably wouldn't provide that route at all, merely using sysfs to
> describe the parameters of the device and buffer being used.

Can we be a little more specific - what in your mind is "very slow"? 
and "fast"?

Is it designated by samples per second? (and bits per sample doesn't matter?) 
or is it the result (bits per sample * samples per second/8 == bytes/second?)

Many people I know would call a 1Mega sample per second converter very slow, 
but the kernel handling a memcpy of a continuous 2Mbyte/second (16-bits per 
sample), stream seems a little wasteful.

Thanks
-Robin
