Return-Path: <linux-kernel-owner+w=401wt.eu-S1758825AbZBZDIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758825AbZBZDIK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:08:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZBZDHz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:07:55 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:40822 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZBZDHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:07:53 -0500
Date: Wed, 25 Feb 2009 20:07:35 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Theodore Tso <tytso@mit.edu>,
       "Martin K. Petersen" <martin.petersen@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
Message-ID: <20090226030735.GA16891@parisc-linux.org>
References: <1235600698-6446-1-git-send-email-matthew@wil.cx> <49A5CBF7.9000501@zytor.com> <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <20090226025043.GJ1363@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226025043.GJ1363@mit.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 25, 2009 at 09:50:43PM -0500, Theodore Tso wrote:
> On Wed, Feb 25, 2009 at 06:27:18PM -0500, Martin K. Petersen wrote:
> > Because of 63-sector legacy problems a bunch of ATA vendors will
> > initially ship 512/4096 drives that are not naturally aligned.
> > I.e. logical sector 63 will be aligned on a 4KB hardware sector
> > boundary to overcome the misaligned default partitioning.
> 
> Are we *sure* that this is what they plan to be doing?  Is there a way
> we can query the hardware to find out for sure what drives are doing
> what?

The drive I have that's pretending to be a 512/4k drive reports this:

$ sudo sg_readcap -l /dev/sdc
Read Capacity results:
   Protection: prot_en=0, p_type=0
   Last logical block address=625142447 (0x2542eaaf), Number of logical blocks=625142448
   Logical block length=512 bytes
   Logical blocks per physical block=3 (log base 2) [actual=8]
   Lowest aligned logical block address=0
Hence:
   Device size: 320072933376 bytes, 305245.3 MiB, 320.07 GB

This disagrees with Martin's assertion.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
