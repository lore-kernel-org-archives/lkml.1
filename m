Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbZAMDlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbZAMDlr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 22:41:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbZAMDli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 22:41:38 -0500
Received: from vms044pub.verizon.net ([206.46.252.44]:35298 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbZAMDlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 22:41:37 -0500
Date: Mon, 12 Jan 2009 22:40:53 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: ACPI hotplug panic with current git head
In-reply-to: <1231807693.27151.21.camel@localhost.localdomain>
X-X-Sender: lenb@localhost.localdomain
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <alpine.LFD.2.00.0901122230130.5859@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <1231604250.3642.33.camel@localhost.localdomain>
 <alpine.LFD.2.00.0901121604380.5859@localhost.localdomain>
 <1231807693.27151.21.camel@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 12 Jan 2009, James Bottomley wrote:

> On Mon, 2009-01-12 at 16:16 -0500, Len Brown wrote:
> > > This is on an IBM Maia system with the calgary IOMMU enabled. It's a
> > > fatal boot up panic.
> > > 
> > 
> > James,
> > A guided bisect...
> > Please let me know which of these fail
> > 
> > a3a798c88a14b35e5d4ca30716dbc9eb9a1ddfe2 is 2.6.29 at ACPI merge
> > efcb3cf7f00c3c424db012380a8a974c2676a3c8 is 2.6.29 before ACPI merge
> 
> Didn't try these (being after the failure)
> 
> > ec9f168fcc344d2ffec1c8c822076bf22dab5c33 is 2.6.28 with most ACPI
> 
> This is the failing one.
> 
> > e8443c358c34f3fe65236e24147ddf0cd0e61b08 is 2.6.28 plus just ACPICA
> 
> This one boots fine.
> 
> > Please test the "2.6.28+ACPICA" one first.
> > If it fails, we are close so you can skip the others above
> > and bisect between that and 2.6.28.
> 
> I'll try bisecting between ec9f168fcc344d2ffec1c8c822076bf22dab5c33 and
> e8443c358c34f3fe65236e24147ddf0cd0e61b08.

Intersting.
The last thing merged into the failing branch was bjorn's _PRT changes
087da3b4e2d7d3ef70a4fa649b9a286fdeb0e44e
If that commit fails, then it is a straight shot back though
his changes to 2.6.28

If his changes work, then there is more to choose from...
b2576e1d4408e134e2188c967b1f28af39cd79d4
'merge brnach 'linus' into release'
is after I updated my tree with Linus' 2.6.29 eggnog-merge-window stuff

3cc8a5f4ba91f67bbdb81a43a99281a26aab8d77 "Merge Branch 'suspend into 
release" is my tree before merging with Linus' stuff

thanks,
-Len

