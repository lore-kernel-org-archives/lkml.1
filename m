Return-Path: <linux-kernel-owner+w=401wt.eu-S934140AbXKPAeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934140AbXKPAeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 19:34:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756731AbXKPAeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 19:34:14 -0500
Received: from smtp124.sbc.mail.sp1.yahoo.com ([69.147.64.97]:41978 "HELO
	smtp124.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756161AbXKPAeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 19:34:13 -0500
X-YMail-OSG: 4S.Jt38VM1lltsBlXxZITep4vUf5AeeCYaA.OFGU5liUk26.yAAu0UTnA4Mf3rUYDwtTRPJubw--
Date: Thu, 15 Nov 2007 16:34:10 -0800
From: Chris Wedgwood <cw@f00f.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com
Subject: Re: 2.6.24-rc2 XFS nfsd hang / smbd too
Message-ID: <20071116003410.GA16797@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org> <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de> <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 15, 2007 at 08:51:36AM +0100, Christian Kujau wrote:

> [<c040914c>] mutex_lock_nested+0xcc/0x2c0
> [<c016dc64>] do_lookup+0xa4/0x190
> [<c016f6f9>] __link_path_walk+0x749/0xd10
> [<c016fd04>] link_path_walk+0x44/0xc0
> [<c016fd98>] path_walk+0x18/0x20
> [<c016ff98>] do_path_lookup+0x78/0x1c0
> [<c0170998>] __user_walk_fd+0x38/0x60
> [<c0169bd1>] vfs_stat_fd+0x21/0x50
> [<c0169ca1>] vfs_stat+0x11/0x20
> [<c0169cc4>] sys_stat64+0x14/0x30
> [<c01028d6>] sysenter_past_esp+0x5f/0xa5

nfsd already wedged up and holds a lock, this is expected.


I'm not sure what you're doing here, but a viable work-around for now
might be to use nfsv2 mounts, something like

  mount -o vers=2 ...

or to keep v3 and disable readdirplus doing something like:

  mount -o vers=3,nordirplus ...

The later I didn't test but was suggested on #linuxfs.
