Return-Path: <linux-kernel-owner+w=401wt.eu-S1757242AbYDPSbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757242AbYDPSbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750974AbYDPSb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 14:31:29 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:59844 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbYDPSb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 14:31:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CxfGjt7K4z011UrJlp0+nZ38Wvi0E1l/2hQbVF8NCVZ4q1nQoVenpk1kJoeEXG4h2BHYI0FWTD/f5nrc949tLuyjUYc08Geq16SIKY6MhQhYKuwrU53muU1loRPTBvIHy2dad5jnwGQ+lm9T9Z8DPejRmvhNGE/rho19NzWqujk=
Message-ID: <87f94c370804161131x300d5a9eyb3341a8fe21e5275@mail.gmail.com>
Date: Wed, 16 Apr 2008 14:31:23 -0400
From: "Greg Freemyer" <greg.freemyer@gmail.com>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Subject: Re: RFC: Self-snapshotting in Linux
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Kernel Newbies" <kernelnewbies@nl.linux.org>
In-Reply-To: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00804160144j25584229t6673bc182fa13b3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 16, 2008 at 4:44 AM, Peter Teoh <htmldeveloper@gmail.com> wrote:
> Sorry if this is a a crazy idea.....just be forewarned....
>
>  First, I would like to make a reference to VMWare's snapshot (name not
>  important, emphasize the idea) feature - hopefully u are familiar with
>  it.   This is a feature whereby u can freeze the entire OS (kernel +
>  userspace application running) and then later reload itself next time,
>  continuing where it left off, without reboot from ground zero.
>
>  Next, can I ask, is such a feature useful in Linux?   Ie, able to
>  restart the kernel + userspace application from where u left off, the
>  last time round.    Not JUST the normal suspend/resume feature, but
>  more important able to CHOOSE among the different available images for
>  u to resume on.   Eg, u want to freeze the current 2.6.25-rc6 kernel,
>  save it, and then restore back the 2.6.23-rc5 image, work on it, save
>  it, and then restore the previous image again.   All done without
>  virtualization as in the VMWare sense - which really is CPU intensive
>  and slow things  down a lot.   Now we can directly execute each OS
>  kernel image on the CPU, and since saving and restoring is quite fast
>  (eg, zipping up the entire physical memory before saving into
>  permanent storage) - I supposed this will be much faster than the
>  normal initialization/fsck work done normally....or did I missed out
>  anything?
>
>  Essentially, to reiterate the key idea:   able to snapshot the current
>  kernel+userspace permanent.....restore from another snapshot....and
>  then switch back again if needed etc.....will the implementation be
>  difficult...if not impossible????
>
>  --
>  Regards,
>  Peter Teoh

By using LVM-2 snapshots you can already do this with data drives.

So if you setup a XEN setup where the DomU boot drives are Dom0 LVs
you should be golden.

Ie. from Dom0 you can create/restore your snapshots of your DomU instances.

It may also be possible to make LVM snapshots work with the root
partition of the physical boot drive, but that would take initrd magic
I have never tried.

Greg
-- 
Greg Freemyer
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
First 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
