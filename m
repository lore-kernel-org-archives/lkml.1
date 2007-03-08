Return-Path: <linux-kernel-owner+w=401wt.eu-S933316AbXCHUyh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933316AbXCHUyh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 15:54:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933315AbXCHUyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 15:54:37 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52746 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933316AbXCHUyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 15:54:36 -0500
Date: Thu, 8 Mar 2007 14:54:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Valdis.Kletnieks@vt.edu
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       safford@watson.ibm.com, serue@linux.vnet.ibm.com,
       kjhall@linux.vnet.ibm.com, zohar@us.ibm.com
Subject: Re: [RFC][Patch 1/6] integrity: new hooks
Message-ID: <20070308205431.GA2750@sergelap.austin.ibm.com>
References: <20070308170001.GA17304@sergelap.austin.ibm.com> <33939.11500.qm@web36612.mail.mud.yahoo.com> <20070308184646.GC21099@sergelap.austin.ibm.com> <200703082038.l28Kcowq023278@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200703082038.l28Kcowq023278@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Valdis.Kletnieks@vt.edu (Valdis.Kletnieks@vt.edu):
> On Thu, 08 Mar 2007 12:46:47 CST, "Serge E. Hallyn" said:
> > I think it should be done as both.  The part which measures the
> > integrity of files should be an integrity subsystem.  The part which
> > uses those results to either allow/refuse actions or take some other
> > action (i.e. shut down the system) should be an lsm.
> 
> That would be good - the allow/deny parts, being security, can use the
> existing LSM hooks, and the integrity part can use the LIM hooks.

Yes, the only problem is that there will still be 'duplication' at some
call sites.  For instance even if something is only doing measurements, at
setxattr, for instance, it still needs to be able to refuse a change if
it can't allocate memory to store measurement data.  So we still might
need an fsnotify-like approach to consolidate security and integrity
hooks.  (As Mimi pointed out, I guess it'll have to make sure to call
the security ones first)

I suppose something more clever might be doable - for instance since we
are pairing the measurement module with an enforcement module, the
enforcement module could kmalloc() what the measurement module will need
for data and return -ENOMEM if need be, then the measurement module just
fills the data in.  If there's no place for it to store the data, then
it knows that the enforcement module must be ok not having that data.

> Umm... wait a minute - *what* Linux Integrity Module hooks? :)

-serge
