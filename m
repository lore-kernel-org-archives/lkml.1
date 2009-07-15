Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbZGOTf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbZGOTf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbZGOTfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 15:35:55 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:40608 "EHLO mx.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbZGOTfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 15:35:55 -0400
Date: Wed, 15 Jul 2009 21:35:52 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Artem Bityutskiy <dedekind@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: Re: Mounting more than one ubifs fails on 2.6.31-rc2
Message-ID: <20090715193552.GA24959@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Artem Bityutskiy <dedekind@infradead.org>,
	linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
References: <20090715113210.GB16289@yamamaya.is-a-geek.org> <1247658731.11353.16.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247658731.11353.16.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy wrote:
> On Wed, 2009-07-15 at 13:32 +0200, Tobias Diedrich wrote:
> > I get the following error when trying to mount a second ubifs:
> > "mount: File exists"
> > Apparently the problem is that ubifs is registered in /sys/class/bdi
> > with it's name 'ubifs' instead of the ubi device major/minor and
> > so can only be registered once.
> > 
> > navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
> > navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
> > mount: File exists
> > navi:/home/ranma# umount /mnt/ubi1
> > navi:/home/ranma# mount -t ubifs ubi0:rootfs /mnt/ubi0
> > navi:/home/ranma# mount -t ubifs ubi1:rootfs /mnt/ubi1
> > mount: File exists
> > 
> > The corresponding kernel error messages is:
> > sysfs: cannot create duplicate filename '/class/bdi/ubifs'
> > 
> 
> Was fixed recently:
> 
> http://git.infradead.org/ubifs-2.6.git?a=commit;h=7fcd9c3ecbf09c0a77db7ba01aac75b32fb79a93

It's indeed fixed in 2.6.31-rc3, sorry for the noise.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
