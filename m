Return-Path: <linux-kernel-owner+w=401wt.eu-S1763374AbZFOPvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763374AbZFOPvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762794AbZFOPv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:51:26 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:40798 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762275AbZFOPvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:51:24 -0400
In-Reply-To: <4A34DA30.1080201@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Daniel Walker <dwalker@soe.ucsc.edu>, Jamie Lokier <jamie@shareable.org>,
       Linux Embedded <linux-embedded@vger.kernel.org>,
       Linux FS Devel <linux-fsdevel@vger.kernel.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Marco <marco.stornelli@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH 00/14] Pramfs: Persistent and protected ram filesystem
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
Message-ID: <OFD1325B2C.7A926EF9-ON882575D6.00567314-882575D6.00571BC3@us.ibm.com>
From: Bryan Henderson <hbryan@us.ibm.com>
Date: Mon, 15 Jun 2009 08:51:28 -0700
X-MIMETrack: Serialize by Router on D01ML604/01/M/IBM(Release 8.5|December 05, 2008) at
 06/15/2009 11:51:25,
	Serialize complete at 06/15/2009 11:51:25
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Marco wrote:
> >    To enable direct
> >    I/O at all times for all regular files requires either that
> >    applications be modified to include the O_DIRECT flag on all file
> >    opens, or that a new filesystem be used that always performs direct
> >    I/O by default."
> 
> This could be done as well by just introducing a "direct_io_only"
> mount option to a file-system which would need this feature.

A mount option would not be the right way.  Mount options are for things 
that are characteristic of the way you're going to access the files. 
_This_ is a characteristic of the block device.  So if one were to make 
this memory accessible with a block device, it would make more sense to 
have a block device ioctl.  And it wouldn't ask the question, "should I 
use direct I/O only," but "does this device have the performance 
characteristics of a classic disk drive?"

But it's possible that there's just no advantage to having a block device 
in the stack here.  When unix block devices were invented, their main 
purpose was that they could reorder reads and writes and do buffering and 
caching -- all things essential for disk drives.  We don't want to stretch 
the concept too far.

--
Bryan Henderson                     IBM Almaden Research Center
San Jose CA                         Storage Systems

