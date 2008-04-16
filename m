Return-Path: <linux-kernel-owner+w=401wt.eu-S1751406AbYDPEId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbYDPEId (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2008 00:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750739AbYDPEIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Apr 2008 00:08:22 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39472 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbYDPEIV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2008 00:08:21 -0400
Date: Wed, 16 Apr 2008 05:08:19 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: Adrian Bunk <bunk@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
       "Q (Igor Mammedov)" <qwerty0987654321@mail.ru>
Subject: Re: Fw: [2.6 patch] make cifs_dfs_automount_list static
Message-ID: <20080416040818.GB27459@ZenIV.linux.org.uk>
References: <OF56FD7422.17D776A1-ON8725742B.006981FF-8625742B.00699B35@us.ibm.com> <524f69650804152058v4b12cfc2xc3c60d42c3e64b32@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524f69650804152058v4b12cfc2xc3c60d42c3e64b32@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2008 at 10:58:06PM -0500, Steve French wrote:
> Merged into cifs-2.6.git tree
> 
> > Adrian Bunk <bunk@kernel.org>
> > 04/14/2008 01:13 PM
> >
> > To
> > Igor Mammedov <niallain@gmail.com>, Steven French/Austin/IBM@IBMUS
> > cc
> > linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
> > Subject
> > [2.6 patch] make cifs_dfs_automount_list static
> >
> >
> > This patch makes the needlessly global cifs_dfs_automount_list static.

This only hides the real problem, namely that logics in the user of said
list is FUBAR.

What kind of eviction policy does cifs want?  "Try to kick all such
mounts out whenever somebody does umount(2) on any mounted cifs instance"?
That's bloody odd, to put it mildly...  "Don't kick them out until
somebody tries to umount cifs instance they are mounted on"?  That's
done automatically from VFS these days (and should've been done that
way as soon as that kind of automounts had been introduced).  "Done
frequently enough"?  Then you want timer, like e.g. NFS does...
