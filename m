Return-Path: <linux-kernel-owner+w=401wt.eu-S1764729AbXH1Teu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764729AbXH1Teu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:34:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932571AbXH1TcS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:32:18 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:35937 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932559AbXH1TcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:32:15 -0400
Date: Tue, 28 Aug 2007 15:31:26 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Christoph Hellwig <hch@infradead.org>, Jeff Layton <jlayton@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Subject: Re: [PATCH 0/4] add killattr inode operation to allow filesystems
	to interpret ATTR_KILL_S*ID bits
Message-ID: <20070828193125.GA27309@filer.fsl.cs.sunysb.edu>
References: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com> <20070828191114.GA3419@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070828191114.GA3419@infradead.org>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 08:11:14PM +0100, Christoph Hellwig wrote:
> 
> Sorry for not replying to the previsious revisions, but I've been out
> for on vacation.
> 
> I can't say I like this version.  Now we've got callouts at two rather close
> levels which is not very nice from the interface POV.
> 
> Maybe preference is for the first scheme where we simply move interpreation
> of the ATTR_KILL_SUID/ATTR_KILL_SGID into the setattr routine and provide
> a nice helper for the normal filesystem to use.
> 
> If people are really concerned about adding two lines of code to the
> handfull of setattr operation there's a variant of this scheme that can
> avoid it:
 
It's not about adding 2 lines of code - it's about adding the requirement
for the fs to call a function.

>  - notify_change is modified to not clear the ATTR_KILL_SUID/ATTR_KILL_SGID
>    but update ia_mode and the ia_valid flag to include ATTR_MODE.
>  - disk filesystems stay unchanged and never look at
>    ATTR_KILL_SUID/ATTR_KILL_SGID, but nfs can check for it and ignore
>    the ATTR_MODE flags and ia_valid in this case and do the right thing
>    on the server side.

Sounds reasonable.

Josef 'Jeff' Sipek.

-- 
I abhor a system designed for the "user", if that word is a coded pejorative
meaning "stupid and unsophisticated."
		- Ken Thompson
