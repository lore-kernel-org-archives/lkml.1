Return-Path: <linux-kernel-owner+w=401wt.eu-S1753688AbZCISCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753688AbZCISCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZCISCg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:02:36 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10968 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZCISCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:02:36 -0400
Date: Mon, 9 Mar 2009 12:01:43 -0600
From: Alex Chiang <achiang@hp.com>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, kay.sievers@vrfy.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: kobj refcounting weirdness
Message-ID: <20090309180143.GG32589@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Matthew Wilcox <matthew@wil.cx>, Greg KH <greg@kroah.com>,
	kay.sievers@vrfy.org, rjw@sisk.pl, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org
References: <20090309063654.GB23137@ldl.fc.hp.com> <20090309150453.GB7627@kroah.com> <20090309165010.GB32589@ldl.fc.hp.com> <20090309165807.GU25995@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090309165807.GU25995@parisc-linux.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Matthew Wilcox <matthew@wil.cx>:
> On Mon, Mar 09, 2009 at 10:50:10AM -0600, Alex Chiang wrote:
> > I thought about the allocators returning a pointer to the same
> > location that maybe has some valid looking data hanging around,
> > but it's not wise for someone like me to go pointing fingers at
> > the allocator before I've proven the bug isn't in my code. ;)
> 
> Slab poisoning would be the logical next thing to try to decide whether
> the allocator is wrong or you're using it wrong ;-)

We had a double free in the PCIe port driver. Removing the double
free seems to fix my issue.

The double free is only in Jesse's linux-next branch, so no need
to worry about it in mainline/stable.

Thanks.

/ac

