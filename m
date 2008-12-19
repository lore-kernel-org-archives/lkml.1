Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbYLSTbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbYLSTbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:31:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYLSTat
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:30:49 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:60298 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbYLSTas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:30:48 -0500
Subject: Re: Notes on support for multiple devices for a single filesystem
From: Chris Mason <chris.mason@oracle.com>
To: Bryan Henderson <hbryan@us.ibm.com>
Cc: Brad Voth <brad@voth.name>, adilger@sun.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>,
       Kay Sievers <kay.sievers@vrfy.org>, linux-btrfs@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
References: <OF3415C20F.793A0D3C-ON88257524.0067548F-88257524.0068BCEC@us.ibm.com>
Content-Type: text/plain
Date: Fri, 19 Dec 2008 14:30:15 -0500
Message-Id: <1229715015.6695.71.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.494BF650.0154:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 11:03 -0800, Bryan Henderson wrote:
> "Brad Voth" <brad@voth.name> wrote on 12/18/2008 01:36:12 PM:
> 
> > I can see the desire to have the snapshot at the filesystem level to
> > ensure that the filesystem knows it is consistent.  However, this 
> > can be a duplication of effort because of the need to have snapshots
> > at the block device level for non-fs devices.  Such as raw logical 
> > devices for say a database.  I would think that a viable consistent 
> > solution would be to have the block device snapshot mechanism have a
> > hook into the filesystem api to say, "I'm preparing to take a 
> > snapshot, please quiesce and return" <take block snapshot> "You may 
> > now resume, Mr. Filesystem"

This is what lvm does now with the write_super_lockfs calls.  They work
well for a specific purpose.

At the end of the day snapshots mean different things to different
people and different workloads.  In lots of ways the lvm snapshots work
very well.

But, doing snapshots at the FS level gives you better performance and
more control.

-chris


