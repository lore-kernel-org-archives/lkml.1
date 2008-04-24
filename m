Return-Path: <linux-kernel-owner+w=401wt.eu-S1761788AbYDXQRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761788AbYDXQRw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 12:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYDXQRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 12:17:43 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49979 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303AbYDXQRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 12:17:42 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424155954.GM15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 16:59:54 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk> <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu> <20080424152129.GK15214@ZenIV.linux.org.uk> <E1Jp3Vz-0004FH-Ih@pomaz-ex.szeredi.hu> <20080424155954.GM15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp47x-0004MY-1W@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 18:16:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > What is left is the guarantee, that the race-free r/o remounts will
> ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > always work and some obscure caller didn't forget to surround it with
> ^^^^^^^^^^^^^^^^^
> 
> > Why are those so important?  Yes, if we have multiple vfs_() calls,
> > surround them with an extra want/drop pair.
> 
> Which leaves you with the same need to audit all these suckers anyway.

Not really.  Missing such calls would just make the *caller* buggy
(i.e. racy with remount r/o), but it would not make the *filesystem*
buggy.  Big difference.

> I'm in principle fine with having such helper functions, *IF* they are
> not sold as providing all protection one needs,

I'm not selling them as that.

> *IF* you are not expecting
> to be able to fold all areas down into them and *IF* original ones are
> left intact.

Left intact for whom, specifically?  Another question you've managed
to avoid answering.

> Modulo the like path_rename(), BTW - that one is just plain ugly API.

I'm all open to improvements.

> > > let alone removing the interface that doesn't require checks to be
> > > vfsmount-based for all users.
> > 
> > What users?  There are paractically _no_ other users.  The ones that
> > there are (like reiserfs) should not be using them, and there are
> > already some patches cleaning that mess up.
> 
> OK, explain me, in small words, WTF should something that wants to do
> operations on filesystem tree have a vfsmount.  Slowly.  And "r/o
> bind loses value if it can be bypassed" is a hogwash - fs methods are
> still there, so it *can* be bypassed just fine, thank you very much.

And we know what to do with such users.

> It's really up to caller.  "But they won't be able to do open()" also
> doesn't fly - again, it's up to whoever writes particular piece of code.

I understand your theory.  But it has zero practical significance.

IOW it doesn't matter that someone _may_ want to access the filesystem
without a vfsmount, if that someone doesn't exist.

Miklos
