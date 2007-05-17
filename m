Return-Path: <linux-kernel-owner+w=401wt.eu-S1762171AbXEQEcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762171AbXEQEcn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 00:32:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXEQEcd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 00:32:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:48873 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXEQEcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 00:32:31 -0400
From: Neil Brown <neilb@suse.de>
To: "Jeff Zheng" <Jeff.Zheng@endace.com>
Date: Thu, 17 May 2007 14:32:11 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17995.56011.742143.418388@notabene.brown>
Cc: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, <linux-raid@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>
Subject: RE: Software raid0 will crash the file-system, when each disk is 5TB
In-Reply-To: message from Jeff Zheng on Thursday May 17
References: <659F626D666070439A4A5965CD6EBF406836C6@gazelle.ad.endace.com>
	<6bffcb0e0705151629j78920ca2r9337dccdfc1bb6a9@mail.gmail.com>
	<17994.19043.771733.453896@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B31C5@gazelle.ad.endace.com>
	<17995.42562.870806.396617@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B33ED@gazelle.ad.endace.com>
	<17995.49602.427417.500049@notabene.brown>
	<659F626D666070439A4A5965CD6EBF406B3428@gazelle.ad.endace.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday May 17, Jeff.Zheng@endace.com wrote:
> I tried the patch, same problem show up, but no bug_on report
> 
> Is there any other things I can do?
> 

What is the nature of the corruption?  Is it data in a file that is
wrong when you read it back, or does the filesystem metadata get
corrupted?

Can you try the configuration that works, and sha1sum the files after
you have written them to make sure that they really are correct?
My thought here is "maybe there is a bad block on one device, and the
block is used for data in the 'working' config, and for metadata in
the 'broken' config.

Can you try a degraded raid10 configuration. e.g.

   mdadm -C /dev/md1 --level=10 --raid-disks=4 /dev/first missing \
   /dev/second missing

That will lay out the data in exactly the same place as with raid0,
but will use totally different code paths to access it.  If you still
get a problem, then it isn't in the raid0 code.

Maybe try version 1 metadata (mdadm --metadata=1).  I doubt that would
make a difference, but as I am grasping at straws already, it may be a
straw woth trying.

NeilBrown
