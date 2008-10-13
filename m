Return-Path: <linux-kernel-owner+w=401wt.eu-S1758578AbYJMLW6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578AbYJMLW6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:22:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755482AbYJMLWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:22:49 -0400
Received: from mail.crca.org.au ([67.207.131.56]:44364 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755348AbYJMLWt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:22:49 -0400
X-Greylist: delayed 579 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Oct 2008 07:22:48 EDT
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [TuxOnIce-devel] safe resuming: automatically invalidating an
	outdated hibernate snapshot
From: Nigel Cunningham <ncunningham@crca.org.au>
To: Martin Steigerwald <ms@teamix.de>
Cc: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
In-Reply-To: <200810131213.51317.ms@teamix.de>
References: <200810131213.51317.ms@teamix.de>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 13 Oct 2008 22:13:05 +1100
Message-Id: <1223896385.11353.9.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Martin.

On Mon, 2008-10-13 at 12:13 +0200, Martin Steigerwald wrote:
> Cc to linux-kernel: This is mainly for tuxonice, but it might also be relevant 
> for other hibernate implementations. Maybe some general mechanism for 
> checking whether an on disk snapshot of the system is current would be good - 
> as also the resume parameter could be missing or wrong or whatnot.
> 
> 
> Hi!
> 
> Is there a way to automatically invalidate the tuxonice snapshot when a non 
> tuxonice kernel is booted accidentally? I.e. could tuxonice recognize when 
> the swap partition has been accessed *after* the snapshot has been written?
> 
> It happened here several times that someone booted the wrong kernel and then 
> someone else booted the right one again. TuxOnIce would then resume from a 
> snapshot that it not up-to-date anymore. This leads to filesystem breakage as 
> the filesystem slab objects and other in memory structures would not 
> represent the current state of the filesystem on disk. xfs_repair did a 
> marvellous job on these occassions and I already changed menu.lst to hide the 
> GRUB boot menu by default, but it would be better if this case of  
> maloperation can be intercepted.

The simplest way is to mkswap the appropriate partitions from a script
run when booting (after we check whether to resume, of course). I
believe the hibernate script already has support for this. Maybe
pm-utils or such like needs it too?

Nigel

