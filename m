Return-Path: <linux-kernel-owner+w=401wt.eu-S1761019AbXFTJST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761019AbXFTJST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbXFTJSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:18:09 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:39533 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbXFTJSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:18:08 -0400
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [ANNOUNCE] Btrfs: a copy on write, snapshotting FS
Date: Wed, 20 Jun 2007 11:18:03 +0200
User-Agent: KMail/1.9.7
Cc: Philipp Matthias Hahn <pmhahn@titan.lahn.de>,
       Chris Mason <chris.mason@oracle.com>,
       =?iso-8859-1?q?P=E1draig_Brady?= <P@draigbrady.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070612161029.GB28279@think.oraclecorp.com> <20070619182813.GA21404@titan.lahn.de> <4678E90A.6000707@vlnb.net>
In-Reply-To: <4678E90A.6000707@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706201118.03939.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mittwoch, 20. Juni 2007, Vladislav Bolkhovitin wrote:
> Philipp Matthias Hahn wrote:
> >>>>I would also suggest one more feature: support for block level
> >>>>de-duplication. I mean:
> So, seems ever for file based de-duplication some support from the FS,
> including some kind of ability for different inodes point to the same
> data blocks to store the meta-data, would be needed anyway.
The easy way is to have the inode point to a (shared, reference counted) data 
storage, which lists the data - then inodes can share the data, but have 
different meta-data.


Ever since I read about filesystems using the files' hash as addressing 
mechanism (per some Linus mail on LKML, about 10 years ago) and manber hashes 
(http://citeseer.ist.psu.edu/manber94finding.html) I'm thinking about various 
ways to use both in a filesystem.

Manber-Hashes allow to split data into similar chunks, which could be 
addresses per some cryptographic checksum, and used by several files.

*But*: The boundaries are not at power-of-2 addresses, so the data for 
read()/mmap() would have to be rebuild somehow. (Would eg. be necessary 
anyway if the data block itself is stored compressed).

The other question I'm still pondering ... File sizes vary very much. If I 
have a large project, eg. the kernel, with many thousand files of some 10 kB, 
some data could be shared - GPL licenses in files, #include lists, and some 
others.
If I have some other data, with files of several hundred megabytes, sharing 
gets more interesting ... but what should the right block size (for manber 
hashes) be? If it's small, we have to concatenate a lot of blocks to 
reconstruct data - if it's big, we might lose many chances for sharing.

And getting good performance, when blocks in the middle of a file have to be 
re-splitted, might be a bit of a problem, too ...



Regards,

Phil

