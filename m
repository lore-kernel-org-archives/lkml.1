Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbXHHHih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbXHHHih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 03:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760005AbXHHHhj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 03:37:39 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:22540 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758966AbXHHHhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 03:37:35 -0400
Date: Wed, 8 Aug 2007 09:38:15 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       satyam@infradead.org, stern@rowland.harvard.edu,
       Tejun Heo <htejun@gmail.com>,
       Linux Containers <containers@lists.osdl.org>, gregkh@suse.de
Subject: Re: [PATCH 0/25] Sysfs cleanups & tagged directory support
Message-ID: <20070808093815.0935a18e@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
References: <11860582832964-git-send-email-htejun@gmail.com>
	<m1643rkqb6.fsf@ebiederm.dsl.xmission.com>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 15:06:21 -0600,
ebiederm@xmission.com (Eric W. Biederman) wrote:

> 
> The following patchset applies on top of the last round of
> sysfs cleanups that Tejun sent out on the 2nd.
> 
> My target with this patchset is to support sysfs directories
> with a tag on struct sysfs_dirent making them visible only
> on selected mounts of sysfs.
> 
> After going around and around the different possibilities I
> believe I have finally found something that works and is
> reasonably maintainable.   I believe I have achieved that
> with only introducing some extra complexity in a few very localized
> places.
> 
> The worst part is the code to support multiple superblocks and thus
> multiple dentry tress for sysfs.  I had allocate a linked list in
> sysfs_move_dir for all of the possible dentries I would need to call
> d_move on. Bleh.  It works, it is correct and it is an atomic
> rename.

My udev failed to create /dev/dasd* so it cannot mount root :( I'm
currently trying to find out what causes this, may take some time...
