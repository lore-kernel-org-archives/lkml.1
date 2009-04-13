Return-Path: <linux-kernel-owner+w=401wt.eu-S1753904AbZDMVuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbZDMVuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbZDMVuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:50:05 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:43677 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbZDMVuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:50:03 -0400
Date: Mon, 13 Apr 2009 16:50:03 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mtk.manpages@gmail.com,
       Stephen Smalley <sds@epoch.ncsc.mil>, Andrew Morgan <morgan@kernel.org>,
       linux-security-module@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, linux-nfs@vger.kernel.org,
       Igor Zhbanov <izh1979@gmail.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>, stable@kernel.org,
       linux-api@vger.kernel.org, Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] add some long-missing capabilities to fs_mask
Message-ID: <20090413215003.GB25085@us.ibm.com>
References: <20090413145614.GA15342@us.ibm.com> <13502.1239656608@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13502.1239656608@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> On Mon, 13 Apr 2009 09:56:14 CDT, "Serge E. Hallyn" said:
> > When POSIX capabilities were introduced during the 2.1 Linux
> > cycle, the fs mask, which represents the capabilities which having
> > fsuid==0 is supposed to grant, did not include CAP_MKNOD and
> > CAP_LINUX_IMMUTABLE.  However, before capabilities the privilege
> > to call these did in fact depend upon fsuid==0.
> 
> Wow. How did this manage to stay un-noticed for this long?

I guess setfsuid() is mainly used by NFS, and not a lot of people
do mknod over NFS?

To run into this, you'd have to do something like

	1. run as root
	2. setresuid(500,500,0);
	3. (...)
	4. setfsuid(0);
	5. mknod(path, mode, dev);

so I suspect the simpler (cross-platform) thing to do was
seteuid(0) for the mknod anyway...  Plus there is nowhere I've
found where the precise capabilities afforded to fsuid=0 are
documented, so noone would complain, they'd just accept it and
do seteuid()?

I'm guessing of course.

-serge
