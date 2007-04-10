Return-Path: <linux-kernel-owner+w=401wt.eu-S1752051AbXDJH0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051AbXDJH0v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 03:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbXDJH0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 03:26:50 -0400
Received: from lazybastard.de ([212.112.238.170]:48121 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbXDJH0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 03:26:49 -0400
Date: Tue, 10 Apr 2007 09:22:53 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Phillip Susi <psusi@cfl.rr.com>,
       Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
Message-ID: <20070410072253.GA28665@lazybastard.org>
References: <20070409000556.GA13980@implementation> <461A5F13.7040705@cfl.rr.com> <461A760B.1040103@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <461A760B.1040103@redhat.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 April 2007 12:21:15 -0500, Eric Sandeen wrote:
> Phillip Susi wrote:
> > 
> > When the filesystem is told to mount the disk read only, that means it 
> > should not write to it.  
> 
> It means the filesystem should not be writeable when it is mounted.
> This is not the same as saying that the filesystem itself should do no
> IO in the course of making that read-only mount available.

The filesystem has two interfaces.  One to the device underneith, one to
userspace.  Read-only should certainly mean that no writes cross the
userspace interface.  Traditionally it has implicitly also meant that
no writes are crossing the device interface.  Whether that was/is an
explicit requirement - who knows.

Journaling filesystems have introduced this thing called "journal
replay".  And I have to admit, it makes thing _a lot_ easier to always
replay the journal, even when being mounted read-only.

But "it is easier" is a pretty lame excuse.

> Under all conditions it should be safe to mount a read-only block
> device, but that is not the same as mounting a filesystem read-only.

In particular, it is a lame excuse when this claim is true.  If the
block-device is read-only, then journal replay will not work as expected
and all the "not so easy" work has to be done anyway.

Did I miss anything?  Is it actually easier to mount a read-only device
with unclean journal than mounting a read-write device and not replay
the journal?

Jörn

-- 
Joern's library part 8:
http://citeseer.ist.psu.edu/plank97tutorial.html
