Return-Path: <linux-kernel-owner+w=401wt.eu-S1752489AbZGXKZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752489AbZGXKZG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 06:25:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752020AbZGXKZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 06:25:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:51999 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbZGXKZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 06:25:04 -0400
From: Ludwig Nussel <ludwig.nussel@suse.de>
To: linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/2] implement uid mount option for ext2 and ext3
Date: Fri, 24 Jul 2009 12:23:57 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.27.23-0.1-default; KDE/4.2.2; x86_64; ; )
References: <1248348991-849-1-git-send-email-ludwig.nussel@suse.de> <10655.1248384221@turing-police.cc.vt.edu>
In-Reply-To: <10655.1248384221@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200907241223.58220.ludwig.nussel@suse.de>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis.Kletnieks@vt.edu wrote:
> On Thu, 23 Jul 2009 13:36:29 +0200, Ludwig Nussel said:
> 
> > The following two patches (for 2.6.31-rc4) therefore implement the
> > uid mount option for ext2 and ext3 to make them actually useful on
> > removable media. My implementation just writes uid 0 to disk for
> > files that are owned by the specified user.
> 
> I'm certain this will end up violating the Principle of Least Surprise.
> 
> For instance - you have UID 500 on 2 systems.  Mount on old system, create a
> file - it's owned by 500.  Take it to a new system, mount it, watch it get
> smashed to 0 because it's owned by "you".  Take it back to the old system, and
> hey, you can't edit your file because it's not owned by 500 anymore...

Yes. However, to actually enable the mapping you have to explicitly
add uid=useruid in the fstab of the new system. So if you know your
uid is the same everywhere just don't do that. Everything behaves as
it does today then. If you use hal for mounting it depends on the
policy files and the GUI whether or not you are allowed to override
that mount option.

> Hint:  This *same exact* problem has been an issue for NFS for at least 25
> years. Might want to think about (a) why Yellow Pages (and later LDAP) was
> developed, and (b) why NFS "root squash" traditionally maps to "nobody" rather
> than a usable UID.

I don't see how that helps us here. Sure, a uid != 0 could be used
for the mapping but which one? The uid of user 'nobody' is not the
same across distros.

cu
Ludwig

-- 
 (o_   Ludwig Nussel
 //\   
 V_/_  http://www.suse.de/
SUSE LINUX Products GmbH, GF: Markus Rex, HRB 16746 (AG Nuernberg)

