Return-Path: <linux-kernel-owner+w=401wt.eu-S1758245AbXFKIbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245AbXFKIbP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 04:31:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXFKIa6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 04:30:58 -0400
Received: from bay0-omc2-s34.bay0.hotmail.com ([65.54.246.170]:13709 "EHLO
	bay0-omc2-s34.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750703AbXFKIa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 04:30:56 -0400
X-Originating-IP: [70.53.13.125]
X-Originating-Email: [seanlkml@sympatico.ca]
Date: Mon, 11 Jun 2007 04:29:19 -0400
From: Sean <seanlkml@sympatico.ca>
To: david@lang.hm
Cc: Crispin Cowan <crispin@novell.com>, casey@schaufler-ca.com,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Message-Id: <20070611042919.8feffc40.seanlkml@sympatico.ca>
In-Reply-To: <Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
References: <700465.32295.qm@web36612.mail.mud.yahoo.com>
	<466C6451.6030907@novell.com>
	<Pine.LNX.4.64.0706102328200.6675@asgard.lang.hm>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.10.11; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jun 2007 08:30:55.0785 (UTC) FILETIME=[D4775190:01C7AC02]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2007 23:45:16 -0700 (PDT)
david@lang.hm wrote:

> say that we give each file a unique label, and for simplicity we set the 
> label == path (note that this raises the issue, what will SELinux do when 
> there are multiple paths to the same file)

So don't do that then.

> now say that you want to grant apache access to all files that have labels 
> that follow the pattern '/home/*/http/* ?
> 
> you are either going to use regex matching, or you are going to have to 
> enumerate every label that matches this (potentially a very large list). 
> and if you try to generate the enumerated list you need to add a label to 
> the list if a file is renamed or created to match the pattern, and delete 
> a file from the list if it is renamed to no longer match the pattern

If AA requires regex matching in the kernel, perhaps it really isn't
appropriate for inclusion.  Surely there has to be a better way than
requiring the kernel to do regex matches at runtime?

> AA over SELinux would need for SELinux to figure out how to handle file 
> creation, file renames, and multiple paths for the same file (hard-links 
> and bind-mounts). In addition a userspace daemon would have to be written 
> to re-label files and/or change policy on the fly as files are renamed. 
> the result would still have race conditions due to the need to re-label 
> large numbers of files

WRONG.  The labels would be obtained from AA as needed, never recorded in
the file attributes.  This would change nothing about what AA needed
to compute at runtime, just the way it implements the result.

> ACPI should have taught everyone that sometimes putting an interpreter in 
> the kernel really is the best option. looking at the problems of bouncing 
> back out to userspace for file creation and renames it looks like a regex 
> in the kernel is a lot safer and more reliable.

There hasn't yet been shown a requirement for a userspace daemon to implement
AA over SeLinux.

Sean
