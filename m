Return-Path: <linux-kernel-owner+w=401wt.eu-S1759741AbYHSUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759741AbYHSUg1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758853AbYHSUfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:35:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58772 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758334AbYHSUfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:35:52 -0400
Date: Tue, 19 Aug 2008 16:33:45 -0400
From: Rik van Riel <riel@redhat.com>
To: Pavel Machek <pavel@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Eric Paris <eparis@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Jan Harkes <jaharkes@cs.cmu.edu>,
       "Press, Jonathan" <Jonathan.Press@ca.com>, peterz@infradead.org,
       linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       hch@infradead.org, andi@firstfloor.org, viro@ZenIV.linux.org.uk
Subject: Re: HSM (was Re: [malware-list] TALPA - a threat model?  well
 sorta.)
Message-ID: <20080819163345.196961f9@riellaptop.surriel.com>
In-Reply-To: <20080819192027.GA6484@ucw.cz>
References: <20080813205906.559d3f37@lxorguk.ukuu.org.uk>
	<2629CC4E1D22A64593B02C43E855530304AE4BC2@USILMS12.ca.com>
	<20080813173529.7069b5f1@cuia.bos.redhat.com>
	<20080815201622.GD31584@cs.cmu.edu>
	<20080815150509.20ffb91d@infradead.org>
	<1219015177.27389.1.camel@localhost.localdomain>
	<20080818163313.72927af7@lxorguk.ukuu.org.uk>
	<20080818124339.4b65b6c0@riellaptop.surriel.com>
	<20080819071416.GA14731@elf.ucw.cz>
	<20080819121032.02632c09@riellaptop.surriel.com>
	<20080819192027.GA6484@ucw.cz>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008 21:20:27 +0200
Pavel Machek <pavel@suse.cz> wrote:

> > If you think FUSE+unionfs is a cleaner solution than one
> > hook in the VFS, I've got a bridge to sell you.
> 
> If you can do it with one clean enough hook, I'll buy that bridge.
> 
> [If you want to do 'list directory before files are there' -- and you
> seem to want to from description above -- fuse seems like a way to
> go.]

For a poor man's HSM, it may be a possibility to simply restore
all the files as sparse files, fetching the content on demand.

The files can be marked as HSM-empty files with some kind of
bit flag or xattr.

Restoring sparse files takes very little time.

This scheme could even work for directories, so you can start
using the filesystem before the whole directory tree has been
restored.

All it needs is block-on-open when the file has a special flag
or xattr set.

-- 
All rights reversed.
