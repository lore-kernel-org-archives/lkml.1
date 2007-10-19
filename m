Return-Path: <linux-kernel-owner+w=401wt.eu-S966920AbXJSXAY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966920AbXJSXAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 19:00:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966708AbXJSW76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:59:58 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:42009 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675AbXJSW74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:59:56 -0400
Date: Fri, 19 Oct 2007 18:59:36 -0400
Message-Id: <200710192259.l9JMxaAT006804@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Erez Zadok <ezk@cs.sunysb.edu>, bfields@fieldses.org,
       nfs@lists.sourceforge.net, neilb@suse.de, linux-kernel@vger.kernel.org
Subject: Re: nfsv2 ref leak in 2.6.24? 
In-reply-to: Your message of "Fri, 19 Oct 2007 17:52:32 EDT."
             <1192830752.7466.32.camel@heimdal.trondhjem.org> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1192830752.7466.32.camel@heimdal.trondhjem.org>, Trond Myklebust writes:
> 
> On Fri, 2007-10-19 at 17:40 -0400, Erez Zadok wrote:
[...]
> > Trond, I was able to narrow down the problem w/o using unionfs at all (yay!
> > :-).  All I do is setup a loop device, mkfs it as ext2, mount it, then
> > export it to localhost and mount it locally as nfs2.  I go and touch a new
> > file in the ext2 directory.  Then I readdir the export point to find the new
> > file indeed.  Then I stat(1) the new file, and get the appropriate stat
> > output.  Now the strange thing is that right after the stat through the
> > export point, the file DISAPPEARS from the lower ext2 dir, but REAPPEARS a
> > few seconds later.
> 
> Let me get this straight:
> 
>   1) You create the file on the server
>   2) You readdir the file from the client
>   3) You stat the file from the client
> 
> ....with the result that the file disappears from sight on the server?

Yup.

> That would indicate some dcache issues with the server code. What export
> options are you using?

The explicit command I use is:

exportfs -o no_root_squash,rw localhost:/n/export/b0

The options recorded in exportfs -v:

/n/export/b0  localhost.localdomain(rw,wdelay,no_root_squash,no_subtree_check,anonuid=65534,anongid=65534)

Erez.
