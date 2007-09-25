Return-Path: <linux-kernel-owner+w=401wt.eu-S1757236AbXIYROY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757236AbXIYROY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 13:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXIYROH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 13:14:07 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:53663 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537AbXIYROF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 13:14:05 -0400
Date: Tue, 25 Sep 2007 10:12:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: Re: [PATCH 1/2] Documentation: move mandatory locking documentation
 to filesystems/
Message-Id: <20070925101240.e006ec75.randy.dunlap@oracle.com>
In-Reply-To: <20070925165551.GG30845@fieldses.org>
References: <46EE3724.80200@openvz.org>
	<1190037331.6700.14.camel@heimdal.trondhjem.org>
	<46EE8C52.80503@openvz.org>
	<1190044850.6700.81.camel@heimdal.trondhjem.org>
	<46EF7136.7080308@openvz.org>
	<20070918151957.GA18476@fieldses.org>
	<1190132095.6656.12.camel@heimdal.trondhjem.org>
	<20070918165220.GE18476@fieldses.org>
	<1190134496.6656.22.camel@heimdal.trondhjem.org>
	<20070918174016.GF18476@fieldses.org>
	<20070925165551.GG30845@fieldses.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2007 12:55:51 -0400 J. Bruce Fields wrote:

> Shouldn't this mandatory-locking documentation be in the
> Documentation/filesystems directory?

Agreed.

> Give it a more descriptive name while we're at it, and update 00-INDEX
> with a more inclusive description of Documentation/filesystems (which
> has already talked about more than just individual filesystems).

OK.
One correction below.

Then
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>


> Signed-off-by: J. Bruce Fields <bfields@citi.umich.edu>
> 
> ---
> 
> On Tue, Sep 18, 2007 at 01:40:16PM -0400, bfields wrote:
> > Hm.  Documentation/mandatory.txt claims that it mandatory locks and
> > mmap() with MAP_SHARED exclude each other, but I can't see where that's
> > enfoced.  That file doesn't make any mention of the above race.
> > 
> > So for now I think someone should update that file and fcntl(2) to
> > mention these problems and to recommend rather strongly against using
> > mandatory locking.
> 
> Anyone have an objection if I submit these two patches to Linus for
> 2.6.24?
> 
> --b.
> 
>  Documentation/00-INDEX                          |    4 +-
>  Documentation/filesystems/00-INDEX              |    2 +
>  Documentation/filesystems/mandatory-locking.txt |  152 +++++++++++++++++++++++
>  Documentation/locks.txt                         |   10 +-
>  Documentation/mandatory.txt                     |  152 -----------------------
>  5 files changed, 160 insertions(+), 160 deletions(-)
>  create mode 100644 Documentation/filesystems/mandatory-locking.txt
>  delete mode 100644 Documentation/mandatory.txt
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 43e89b1..910473c 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -145,7 +145,7 @@ fb/
>  feature-removal-schedule.txt
>  	- list of files and features that are going to be removed.
>  filesystems/
> -	- directory with info on the various filesystems that Linux supports.
> +	- info on the vfs and the various filesystems that Linux supports.
>  firmware_class/
>  	- request_firmware() hotplug interface info.
>  floppy.txt
> @@ -240,8 +240,6 @@ m68k/
>  	- directory with info about Linux on Motorola 68k architecture.
>  magic-number.txt
>  	- list of magic numbers used to mark/protect kernel data structures.
> -mandatory.txt
> -	- info on the Linux implementation of Sys V mandatory file locking.
>  mca.txt
>  	- info on supporting Micro Channel Architecture (e.g. PS/2) systems.
>  md.txt
> diff --git a/Documentation/filesystems/00-INDEX b/Documentation/filesystems/00-INDEX
> index 59db1bc..73c8e94 100644
> --- a/Documentation/filesystems/00-INDEX
> +++ b/Documentation/filesystems/00-INDEX
> @@ -52,6 +52,8 @@ isofs.txt
>  	- info and mount options for the ISO 9660 (CDROM) filesystem.
>  jfs.txt
>  	- info and mount options for the JFS filesystem.
> +mandatory

   mandatory-locking.txt

> +	- info on the Linux implementation of Sys V mandatory file locking.
>  ncpfs.txt
>  	- info on Novell Netware(tm) filesystem using NCP protocol.
>  ntfs.txt

---
~Randy
Phaedrus says that Quality is about caring.
