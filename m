Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbYC0IeC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbYC0IeC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 04:34:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYC0Idv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 04:33:51 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:51740 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYC0Idu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 04:33:50 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <20080326224455.GV10722@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 26 Mar 2008 22:44:55 +0000)
Subject: Re: [patch 6/7] vfs: mountinfo: add /proc/<pid>/mountinfo
References: <20080326211131.705321084@szeredi.hu> <20080326212143.479034123@szeredi.hu> <20080326224455.GV10722@ZenIV.linux.org.uk>
Message-Id: <E1JenXl-0006x4-Po@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 27 Mar 2008 09:33:05 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +This file contains lines of the form:
> > +
> > +36 35 98:0 /mnt1 /mnt2 rw,noatime rw master:1 - ext3 /dev/root,errors=continue
> > +(1)(2)(3)   (4)   (5)      (6)    (7)  (8)   (9) (10)   (11)      (12)
> > +
> > +(1) mount ID:  unique identifier of the mount (may be reused after umount)
> > +(2) parent ID:  ID of parent (or of self for the top of the mount tree)
> > +(3) major:minor:  value of st_dev for files on filesystem
> > +(4) root:  root of the mount within the filesystem
> > +(5) mount point:  mount point relative to the process's root
> > +(6) mount options:  per mount options
> 
> > +(7) super options:  filesystem type independent, per super block options
> 
> Move that one past fs type, please.

Can you please be a bit more specific?  Because getting this right
iteratively is going to be tiring.

36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 rw /dev/root,errors=continue

or

36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root,rw,errors=continue

or perhaps

36 35 98:0 /mnt1 /mnt2 rw,noatime master:1 - ext3 /dev/root rw,errors=continue

or something else?

Miklos
