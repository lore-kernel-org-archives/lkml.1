Return-Path: <linux-kernel-owner+w=401wt.eu-S1758829AbYG3SQa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758829AbYG3SQa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 14:16:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbYG3SQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 14:16:20 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:49103 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752369AbYG3SQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 14:16:19 -0400
Date: Wed, 30 Jul 2008 14:13:52 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: Jim Meyering <jim@meyering.net>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
Subject: Re: tools support for non-512 byte sector sizes
Message-ID: <20080730181351.GA5347@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matt Domsch <Matt_Domsch@dell.com>, Jim Meyering <jim@meyering.net>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Matthew Wilcox <matthew@wil.cx>, Ric Wheeler <rwheeler@redhat.com>,
	linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org, Jeff Garzik <jeff@garzik.org>
References: <488F524F.6020905@redhat.com> <20080729182611.GB24924@parisc-linux.org> <1217356645.6103.48.camel@localhost.localdomain> <yq13alsr0g0.fsf@sermon.lab.mkp.net> <20080730135147.GA4513@auslistsprd01.us.dell.com> <87zlnzb8ce.fsf@rho.meyering.net> <20080730172922.GA20191@auslistsprd01.us.dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730172922.GA20191@auslistsprd01.us.dell.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 12:29:22PM -0500, Matt Domsch wrote:
> 2) those that report a 512-byte sector size, but are really a
>    4096-byte size, and the drive does the conversions and
>    read/modify/write.  T10 and T13 are looking to add commands to
>    expose this different underlying physical sector size so the OS
>    could be aware of it.  This is primarily being driven to mitigate
>    any problems that may happen with "legacy" OSs that are not aware
>    of the difference.

As usual, the biggest problem will be "legacy" userspace.  For
example, most partition tools are still generating legacy partition
tables that look like this:

Disk /dev/sda: 255 heads, 63 sectors, 38913 cylinders

Nr AF  Hd Sec  Cyl  Hd Sec  Cyl     Start      Size ID
 1 80   1   1    0 254  63  121         63    1959867 83
 2 00   0   1  122 254  63  619    1959930    8000370 82
 3 00   0   1  620 254  63 1023    9960300  615177045 05
 4 00   0   0    0   0   0    0          0          0 00
 5 00   1   1  620 254  63 1023         63  615176982 8e

Note the starting sector# for the first partition.....

						- Ted
