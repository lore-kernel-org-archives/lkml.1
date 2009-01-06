Return-Path: <linux-kernel-owner+w=401wt.eu-S1762169AbZAFWmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762169AbZAFWmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 17:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758589AbZAFWmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 17:42:24 -0500
Received: from mail-out1.uio.no ([129.240.10.57]:43495 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757750AbZAFWmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:42:22 -0500
Subject: Re: [RFC][PATCH 2/4] sunrpc: Use utsnamespaces
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Matt Helsley <matthltc@us.ibm.com>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-nfs@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Chuck Lever <chuck.lever@oracle.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Cedric Le Goater <clg@fr.ibm.com>
In-Reply-To: <20090106215831.GE18147@us.ibm.com>
References: <20090106011314.534653345@us.ibm.com>
	 <20090106011314.961946803@us.ibm.com> <20090106200229.GA17031@us.ibm.com>
	 <1231274682.20316.65.camel@heimdal.trondhjem.org>
	 <20090106215831.GE18147@us.ibm.com>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 17:42:12 -0500
Message-Id: <1231281732.4173.6.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 3CDC04F290650C57C1CDE2E4CB7FB788DFFDB355
X-UiO-SPAM-Test: remote_host: 68.40.183.129 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 327 max/h 9 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 15:58 -0600, Serge E. Hallyn wrote:

> So should we use patch 2/4, plus (as someone - was it you? - suggested)
> using a DEFAULT instead of init_utsname()->nodename when
> current->utsname() == NULL?

No. I'm don't think that 2/4 is correct either. Basically, 2/4 is saying
that the container that first mounts the filesystem 'owns' it. However
at the same time we know that the lifetime of the filesystem is in no
way bounded by the lifetime of the container, and that's what gets you
into trouble with 'umount' in the first place.

IMO, the current code is the most correct approach, in that it assumes
that the filesystems are owned by the 'init' namespace.

Trond

