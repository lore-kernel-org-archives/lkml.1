Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbZDGMjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbZDGMjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 08:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754976AbZDGMjm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 08:39:42 -0400
Received: from vps1.tull.net ([66.180.172.116]:35674 "HELO vps1.tull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755007AbZDGMjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 08:39:41 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Apr 2009 08:39:41 EDT
Date: Tue, 7 Apr 2009 22:31:48 +1000
From: Nick Andrew <nick@nick-andrew.net>
To: don fisher <hdf3@comcast.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH try #1] Kconfig: cleanup block/Kconfig help descriptions
Message-ID: <20090407123148.GA11750@mail.local.tull.net>
References: <20080223225640.20233.12405.stgit@marcab.local.tull.net> <49BDC438.6080900@comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49BDC438.6080900@comcast.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SMTPD: qpsmtpd/0.26, http://develooper.com/code/qpsmtpd/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 08:15:04PM -0700, don fisher wrote:
> Nick,
>
> I am trying to configure a linux-2.6.28.7 kernel.
>
> Please explain why the switch for large block devices should be !64BIT.  
> I have a 64BIT system and currently cannot generate files greater than  
> 2TB. Is this the problem? Should this be true for 64BIT systems?

Sorry I didn't see this email earlier.

Probably due to this:

#ifdef CONFIG_LBD
typedef u64 sector_t;
typedef u64 blkcnt_t;
#else
typedef unsigned long sector_t;
typedef unsigned long blkcnt_t;
#endif

With a 64-bit machine, your sector_t and blkcnt_t are already 64 bits
wide, so CONFIG_LBD is not required.

Nick.
