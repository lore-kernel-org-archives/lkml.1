Return-Path: <linux-kernel-owner+w=401wt.eu-S1752250AbXDXTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250AbXDXTCF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 15:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754428AbXDXTCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 15:02:04 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:60629 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752250AbXDXTCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 15:02:03 -0400
Date: Tue, 24 Apr 2007 11:27:25 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Nikita Danilov <nikita@clusterfs.com>
cc: Amit Gud <gud@cis.ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com,
       riel@surriel.com, zab@zabbo.net, arjan@infradead.org,
       suparna@in.ibm.com, brandon@ifup.org, karunasagark@gmail.com,
       gud@ksu.edu
Subject: Re: [RFC][PATCH] ChunkFS: fs fission for faster fsck
In-Reply-To: <17965.60841.900376.524639@gargle.gargle.HOWL>
Message-ID: <Pine.LNX.4.63.0704241123200.7701@qynat.qvtvafvgr.pbz>
References: <Pine.LNX.4.64.0704230544450.1682@camaro.cis.ksu.edu>
 <17965.60841.900376.524639@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2007, Nikita Danilov wrote:

> Amit Gud writes:
>
> Hello,
>
> >
> > This is an initial implementation of ChunkFS technique, briefly discussed
> > at: http://lwn.net/Articles/190222 and
> > http://cis.ksu.edu/~gud/docs/chunkfs-hotdep-val-arjan-gud-zach.pdf
>
> I have a couple of questions about chunkfs repair process.
>
> First, as I understand it, each continuation inode is a sparse file,
> mapping some subset of logical file blocks into block numbers. Then it
> seems, that during "final phase" fsck has to check that these partial
> mappings are consistent, for example, that no two different continuation
> inodes for a given file contain a block number for the same offset. This
> check requires scan of all chunks (rather than of only "active during
> crash"), which seems to return us back to the scalability problem
> chunkfs tries to address.

not quite.

this checking is a O(n^2) or worse problem, and it can eat a lot of memory in 
the process. with chunkfs you divide the problem by a large constant (100 or 
more) for the checks of individual chunks. after those are done then the final 
pass checking the cross-chunk links doesn't have to keep track of everything, it 
only needs to check those links and what they point to

any ability to mark a filesystem as 'clean' and then not have to check it on 
reboot is a bonus on top of this.

David Lang

> Second, it is not clear how, under assumption of bugs in the file system
> code (which paper makes at the very beginning), fsck can limit itself
> only to the chunks that were active at the moment of crash.
>
> [...]
>
> >
> > Best,
> > AG
>
> Nikita.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
