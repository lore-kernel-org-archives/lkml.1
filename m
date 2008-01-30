Return-Path: <linux-kernel-owner+w=401wt.eu-S1757521AbYA3NHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757521AbYA3NHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 08:07:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754195AbYA3NHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 08:07:09 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:37769 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbYA3NHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 08:07:08 -0500
Date: Wed, 30 Jan 2008 13:06:56 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>, trivial@kernel.org,
       linux-fsdevel@vger.kernel.org, apw@shadowen.org, rdunlap@xenotime.net,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 8/9] bfs: remove multiple assignments
Message-ID: <20080130130656.GI27894@ZenIV.linux.org.uk>
References: <1201296027-6900-1-git-send-email-dmitri.vorobiev@gmail.com> <1201296027-6900-9-git-send-email-dmitri.vorobiev@gmail.com> <Pine.LNX.4.61.0801261833270.1966@ginsburg.homenet> <479BC6E5.5000409@gmail.com> <479D7DEB.7070806@austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479D7DEB.7070806@austin.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 01:02:03AM -0600, Joel Schopp wrote:
> >>>-    inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME_SEC;
> >>>+    inode->i_mtime = CURRENT_TIME_SEC;
> >>>+    inode->i_atime = CURRENT_TIME_SEC;
> >>>+    inode->i_ctime = CURRENT_TIME_SEC;
> >>multiple assignments like "x = y = z = value;" can potentially
> >>(depending on the compiler and arch) be faster than "x = value; y =
> >>value; z=value;"
> >>
> >>I am surprized that this script complains about them as it is a
> >>perfectly valid thing to do in C.
> >
> >I think it seems wise to ask the maintainers of checkpatch.pl to
> >comment on that. I'm Cc:ing them now.
> >
> 
> There are plenty of things that are valid to do in C that don't make for 
> maintainable code.  These scripts are designed to make your code easier for 
> real people to review and maintain.

Except that in this case the new variant is not equivalent to the old one...
