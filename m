Return-Path: <linux-kernel-owner+w=401wt.eu-S1759488AbXH0SlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488AbXH0SlS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 14:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756008AbXH0SlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 14:41:05 -0400
Received: from mail.fieldses.org ([66.93.2.214]:50427 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756885AbXH0SlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 14:41:04 -0400
Date: Mon, 27 Aug 2007 14:40:59 -0400
To: Gabriel Barazer <gabriel@oxeva.fr>
Cc: nfsv4@linux-nfs.org, nfs@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, jkar8572@users.sourceforge.net
Subject: Re: nfs4 filesystem mounted via the "bind" option reports wrong
	fstype
Message-ID: <20070827184059.GI3118@fieldses.org>
References: <46D318D3.9020101@oxeva.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46D318D3.9020101@oxeva.fr>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2007 at 08:32:51PM +0200, Gabriel Barazer wrote:
> Hi,
> 
> A nfs4 filesystem, mounted elsewhere via the "bind" option (the usual 
> way to do with nfsv4 and its pseudofs), reports wrong fstype "nfs" 
> instead of "nfs4" filesystem.
> An example is much easier to understand :
> Server-side :
> - /exports is the pseudo root filesystem (fsid=0 option in /etc/exports)
> - /exports/data is a mountpoint for another filesystem (not the same 
> device-id as /exports). This condition seems to be what triggers the bug
> - /exports/data must be exported with the "nohide" option (again, the 
> usual way to do se with nfsv4)
> 
> Client-side :
> - mount server:/  on /imports
> - mount "bind" /imports/data on /home/data

There's no reason not to just mount server:/exports/data directly at
/home/data; the bind mounts are just a workaround for the somewhat
primitive exports facility on the server side.

> (this magically shows a second nfs mount in /proc/mounts)
> And here is the bug : this second mount is of fstype "nfs" instead of 
> "nfs4" although the options field contains "vers=4".

But, yes, that sounds like a bug, thanks.

--b.
