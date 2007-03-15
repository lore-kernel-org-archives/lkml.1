Return-Path: <linux-kernel-owner+w=401wt.eu-S1753397AbXCOWsa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397AbXCOWsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 18:48:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXCOWsa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 18:48:30 -0400
Received: from main.gmane.org ([80.91.229.2]:49487 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXCOWs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 18:48:29 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
Subject: Re: [PATCH] Fix =?utf-8?b?Q09NUEFUX1ZEU08=?= regression bug
Date: Thu, 15 Mar 2007 22:47:34 +0000 (UTC)
Message-ID: <loom.20070315T233648-47@post.gmane.org>
References: <45F88780.1080507@wldelft.nl> <20070315110714.a22581b2.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 145.9.190.39 (Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070219 Firefox/2.0.0.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm <at> linux-foundation.org> writes:

> >     Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
> >     This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.
> > 
> >     Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
> >     reported in bug #8040. Reverting the above patch solved the problem.

> I think reverting it is probably the right thing to do, unless we can fix
> it for real quite promptly.

Chuck Ebbert at redhat.com asked:

> Can you please double check this by trying with/without again -- sometimes
bisects go bad.

As requested I started to redo the test but now without git
using kernel.org tars. The results now are, still using the same .config:
linux-2.6.20.tar.gz  : bad
linux-2.6.20.1.tar.gz: bad (boot log equal)
linux-2.6.20.2.tar.gz: good
linux-2.6.20.3.tar.gz: good
(triple checked)

Chuck is right, the bisect gone bad.
I asked Nilshar to try these kernels too with:
COMPAT_VDSO=y
CONFIG_HIGHMEM64G=y

He did and says 2.6.20.3 works fine. So only 2.6.20 and 2.6.20.1 had
this 'hang' at boot behavior on my Supermicro 7044 while Nilshar's
machine started working with 2.6.20.3

Reverting avoided imo. I hope more people cheer up who reported bug #8040
and confirm it's fine with the latest stable.

