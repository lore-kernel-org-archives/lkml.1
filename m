Return-Path: <linux-kernel-owner+w=401wt.eu-S1763316AbXEQHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763316AbXEQHKW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 03:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755809AbXEQHKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 03:10:11 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:41523 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755328AbXEQHKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 03:10:09 -0400
Date: Thu, 17 May 2007 12:47:20 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Convert namespace_sem to a mutex
Message-ID: <20070517071720.GC4462@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20070517045041.GA4462@in.ibm.com> <20070517050046.GM4095@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070517050046.GM4095@ftp.linux.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2007 at 06:00:46AM +0100, Al Viro wrote:
> On Thu, May 17, 2007 at 10:20:41AM +0530, Bharata B Rao wrote:
> > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > 
> > namespace_sem is a rwsem. It is acquired as read sem at only one place(used
> > by /proc/mounts, /proc/<pid>/mounts and /proc/<pid>/mountstats). In all other
> > cases it is acquired as a write sem. So, as there is not more than one reader
> > for this sem, this can be a generic sem (and not rwsem) and if so it can be
> > a mutex.
> 
> Except that read accesses outnumber write ones by far and we have no reason
> for serializing them against each other.  NAK.

Ok, I wasn't aware that this rwsem had many concurrent readers. From whatever
little I could see (during system boot and during kernel compilation with
make -j), the number of concurrent readers very rarely touched 3 and was 1
mostly. May be there are other concurrent readers of this sem. Any idea
from where they could be coming from ?

Regards,
Bharata.
