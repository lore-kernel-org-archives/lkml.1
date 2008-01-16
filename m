Return-Path: <linux-kernel-owner+w=401wt.eu-S1758372AbYAPRPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372AbYAPRPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753005AbYAPRNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:13:34 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52197 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757717AbYAPRNd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:13:33 -0500
Date: Wed, 16 Jan 2008 12:13:27 -0500
Message-Id: <200801161713.m0GHDRUN023917@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Paul Albrecht <albrecht@rdi1.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: unionfs, cow, and whiteout 
In-reply-to: Your message of "Wed, 16 Jan 2008 10:27:13 CST."
             <1200500833.11000.0.camel@thinix-laptop> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1200500833.11000.0.camel@thinix-laptop>, Paul Albrecht writes:
> Hi,
> 
> I have a question about how unionfs handles file deletion when a write
> enabled file system is union mounted over a read only file system. For
> example, I do something like the following:
> 
> mount -t unionfs -o dirs=/cow=rw:/rofs=ro unionfs /mnt
> 
> If I create and delete a file in /mnt which is not present in /rofs it
> persists as whiteout in the cow file system which is not what I would
> have expected.

Paul, the alternative is to scan all branches (there could be many) to
ensure that the file may not exist by that name anywhere else, and if so,
try to delete all instances of it.  This was deemed too expensive and
complex.

Another possible problem is that if you choose to insert a new branch in the
middle, and you didn't have the whiteout, you may re-expose the file name
unintentionally.

You might want to take a look at our unionfs-odf version: it places
whiteouts in a separate persistent store outside the branches, not as .wh.*
files in individual branches.

> Why does the deleted file persist as whiteout in the /cow file system of
> the union mount?
> 
> Please cc me in your response as I'm not subscribed to the lkml.
> 
> -- 
> 
> Paul Albrecht

Cheers,
Erez.
