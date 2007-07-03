Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXGCW2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXGCW2z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 18:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758100AbXGCW2s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 18:28:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:48619 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757734AbXGCW2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 18:28:46 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [AppArmor 01/44] Pass struct vfsmount to the inode_create LSM hook
Date: Wed, 4 Jul 2007 00:28:30 +0200
User-Agent: KMail/1.9.5
Cc: jjohansen@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Tony Jones <tonyj@suse.de>,
       Dave Hansen <hansendc@us.ibm.com>
References: <20070626230756.519733902@suse.de> <20070626230851.325388038@suse.de> <20070630092934.GA22354@infradead.org>
In-Reply-To: <20070630092934.GA22354@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
X-Length: 1517
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200707040028.30273.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 30 June 2007 11:29, Christoph Hellwig wrote:
> On Tue, Jun 26, 2007 at 04:07:57PM -0700, jjohansen@suse.de wrote:
> > This is needed for computing pathnames in the AppArmor LSM.
>
> Please see the various per-mountpoint r/o thread that NACKed all the
> vfsmount additions and have the rationale for it.

The per-mountpoint flags can be checked at the vfs level instead of checking 
down in the filesystems. That's all pretty nice; it avoids a number of 
problems. (I think the latest patches of Dave Hansen are archived at 
http://lwn.net/Articles/239630/.)

The lSM hooks are a rather different story: we cannot move LSM functionality 
into the vfs without breaking the LSM abstraction. LSMs already are not 
agnostic of vfsmount anymore right now. They are free to use the additional 
vfsmounts, or just ignore them.

So what are the specific issues you have with this?

Thanks,
Andreas
