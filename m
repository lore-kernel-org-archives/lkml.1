Return-Path: <linux-kernel-owner+w=401wt.eu-S1758351AbYFSLL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758351AbYFSLL0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 07:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756953AbYFSLLP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 07:11:15 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:57567 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756034AbYFSLLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 07:11:14 -0400
Date: Thu, 19 Jun 2008 07:09:47 -0400
From: Theodore Tso <tytso@mit.edu>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
       Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Performance of ext4
Message-ID: <20080619110947.GB11516@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Holger Kiehl <Holger.Kiehl@dwd.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de> <20080612180605.GD22481@skywalker> <Pine.LNX.4.64.0806121940020.2974@diagnostix.dwd.de> <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806180546370.20901@diagnostix.dwd.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 05:58:00AM +0000, Holger Kiehl wrote:
> For afdbench: 5336.41 files per second 15.63 MiB/s
>
> So it seems that for afdbench the ext4-patch-queue is a slowdown.

Can you remind me where afdbench can be downloaded?  And if I remember
correctly, it creates and deletes large numbers of small files,
correct?

It would be interesting to see which new feature introduced by the
ext4 patch queue --- probably dellayed allocation or mballoc --- is
responsible for the slowdown.  One or the other (or both) can be
disabled by mounting the filesystem (using a kernel with the ext4
patch queue) with the mount options -O nomballoc or -O nodelalloc.

If it turns out that nomballoc restores the speed for afdbench, for
example, then it will tell us where we need to look more closely.
Ideally we would not want to have one mount option needed to optimize
filesystem operations for large amoutns of modifications to small
files, and another mode of operation when mostly writing to large
files.  So if you could do a round of tests using the ext4 patch queue
kernel, with -O nomballoc and -O nodelalloc (and if both seem to
improve things, try "-O nomballoc,nodelalloc" and see if you get back
to the pre-ext4 patch queue speed), it would be very much appreciated.

Thanks, regards,

						- Ted
