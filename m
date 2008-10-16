Return-Path: <linux-kernel-owner+w=401wt.eu-S1753509AbYJPNsI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbYJPNsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 09:48:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbYJPNrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 09:47:46 -0400
Received: from ryu.zarb.org ([212.85.158.22]:33438 "EHLO ryu.zarb.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753810AbYJPNrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 09:47:45 -0400
Subject: Re: Possible ext3 corruption with 1K block size
From: Pascal Terjan <pterjan@mandriva.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, pterjan@mandriva.org,
       linux-ext4@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <48F601A5.1050405@redhat.com>
References: <200810150724.42180.arvidjaar@mail.ru>
	 <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>
	 <48F601A5.1050405@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Mandriva
Date: Thu, 16 Oct 2008 15:47:40 +0200
Message-Id: <1224164860.11578.14.camel@plop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.0-2mdv2009.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 15 octobre 2008 à 09:43 -0500, Eric Sandeen a écrit :
> Andrey Borzenkov wrote:
> > On Wednesday 15 October 2008, Eric Sandeen wrote:
> 
> 
> >> My kingdom for a testcase... does anyone have simple steps to reproduce
> >> this?  Or do they all start with "install mandriva on a 1k block size
> >> system?"  :)
> >>
> > 
> > May be RH will do? :)
> 
> I did try a 1k-block root fs Fedora install, and didn't see any problems...
> 
> > As indicated by last comment, Pascal has some ways to trigger it; I
> > forgot to Cc to him initially; doing it now.
> 
> Ok, good deal.
> 

On my test machine I reproduce it easily : rpm --rebuilddb and if the db
is not detected to be corrupted yet it will be after installing a few
packages (tested again with 2.6.27).

If I do the rebuilddb on a 2.6.17 and then reboot on a recent kernel,
then I can install/uninstall thousands of packages without any
corruption.

I wanted to try a few things including copying the partition to a file
and trying to reproduce in a vm.

Given how I can reproduce and repair it i can even write a bisecting
script which would basically be an initscript which would do

if on test kernel
- rebuild the db
- install 10 rpm
- remove the 10 rpm
- check the db
- do the good/bad
- reboot onto 2.6.17
else if on 2.6.17
- rebuild the db
- build the kernel
- reboot on test kernel

and let it run :)

All I need is to find some time with nothing more urgent...

