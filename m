Return-Path: <linux-kernel-owner+w=401wt.eu-S1760594AbYDNNwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760594AbYDNNwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 09:52:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759970AbYDNNwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 09:52:16 -0400
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:49802 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759923AbYDNNwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 09:52:15 -0400
Date: Mon, 14 Apr 2008 09:52:14 -0400
To: Frans Pop <elendil@planet.nl>
Cc: Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: Re: No IDE drivers loaded for Toshiba Satellite 320 CDS
Message-ID: <20080414135214.GC7385@csclub.uwaterloo.ca>
References: <200804021524.27222.elendil@planet.nl> <200804031947.07674.elendil@planet.nl> <48017248.4030600@gmail.com> <200804131559.21664.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200804131559.21664.elendil@planet.nl>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2008 at 03:59:20PM +0200, Frans Pop wrote:
> I totally agree. The problem being discussed here is exactly how to know it 
> is needed. If you have better suggestions for that, I'd appreciate it.
> 
> As you specifically say "modern controllers", I suspect that the problem is 
> limited as I guess those are fairly unlikely to be found in machines that 
> have an ISA bus.
> 
> I also think the way I've implemented in the Debian installer should be 
> relatively safe:
> 1) ide-generic is only loaded _after_ any otherwise detected modules
> 2) it is only loaded if an ISA bus is present
> 3) it is only included in the initrd for the installed system if loading it
>    in the installer resulted in additional block devices appearing

OK, great for x86 perhaps, what about other systems?

> I would unload ide-generic in the installer if no additional block devices 
> appear, but unfortunately that's not possible as it is marked "permanent".
> 
> By loading it after any other drivers I expect there will be no issues 
> during the installation (as the other driver will already have claimed the 
> device). Making sure it is only loaded for the installed system if actually 
> needed should avoid problems there.
> 
> ATM I can only see this causing problems in systems that need both 
> ide-generic and some other driver as adding ide-generic in the initrd is 
> likely to result in it being loaded before that other driver.

In the past debian would load ide-generic last.  It worked great.  Keep
doing that.  I am not aware of loading ide-generic after all the other
drivers ever causing any harm in the older debian installers.

> Again, if anyone has a better suggestion how to implement this (preferably 
> without asking the user whether he has a device that needs ide-generic, 
> which most users are unlikely to know anyway), I'd appreciate it.

I would say just load the generic driver and let it grab whatever other
drivers haven't already.  If this causes a problem, then there is a
kernel bug to be fixed.  It shouldn't be the installers problem.  After
all what happens if ide-generic and all the other drivers are built in
rather than modules?  If that broke then the kernel already has issues,
and as far as I can tell that isn't a problem.

So just load it.  If it didn't cause any additional ide ports to appear,
then you can unload it again.

-- 
Len Sorensen
