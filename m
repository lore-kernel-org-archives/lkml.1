Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbXDKQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbXDKQnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbXDKQnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 12:43:41 -0400
Received: from khc.piap.pl ([195.187.100.11]:36126 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbXDKQnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 12:43:40 -0400
To: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Gene Heskett <gene.heskett@gmail.com>,
       linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
References: <200704091007.58535.gene.heskett@gmail.com>
	<200704100353.14208.gene.heskett@gmail.com>
	<461BDFEA.8040602@cfl.rr.com>
	<200704110001.40573.gene.heskett@gmail.com>
	<461CF4D9.2000302@cfl.rr.com>
	<alpine.DEB.0.83.0704111109390.13251@sigma.j-a-k-j.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Wed, 11 Apr 2007 18:43:38 +0200
In-Reply-To: <alpine.DEB.0.83.0704111109390.13251@sigma.j-a-k-j.com> (John Anthony Kazos, Jr.'s message of "Wed, 11 Apr 2007 11:12:19 -0400 (EDT)")
Message-ID: <m3mz1e275x.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"John Anthony Kazos Jr." <jakj@j-a-k-j.com> writes:

> I think that's especially true. If a user begins with a single full disk 
> for their entire filesystem, uses tar to backup, and then later adds a 
> second disk, copies everything from /usr and /home onto partitions there 
> (making sure to preserve all interesting bits like ctime/mtime), and 
> mounts them over the original directories, tar should not decide that 
> every file in /usr and /home was deleted and recreated.

That wouldn't work, even if you managed to copy ctime, the target
inode number will be different than the original and backup has
to assume it's a different file.

For filesystems with no stable inode numbers my backup scheme
assumes that the same file = the same name and times but it's
really fragile.

An option to ignore block device number does make sense, of course.
Especially when backing up only one filesystem (-xdev etc).
-- 
Krzysztof Halasa
