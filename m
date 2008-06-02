Return-Path: <linux-kernel-owner+w=401wt.eu-S1757949AbYFBRWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949AbYFBRWl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 13:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752817AbYFBRWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 13:22:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:13253 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbYFBRWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 13:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UqpeN3dJ9D6LFY10P1l6cYgLcUBw6KjUf9utbavUt0JdUcxUAo9rmrzMTZXaSFhVmx9ooGw7RmUnwUKcD4M6+DPFXnItRK570x/61w4lVyoUNw2RfmQBJcp5YjtuzgVMfVk+6FXfkaRAPCBQWxbcvb08z8oKZrqXUFOUA/7lLqc=
Message-ID: <5f7c1d2c0806021022t67d07733p47b78d351dcf63b6@mail.gmail.com>
Date: Tue, 3 Jun 2008 01:22:28 +0800
From: "Xiaoming Li" <forrubm2@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical volume manager as a virtual device driver when physical spaces run out?
Cc: "Rik van Riel" <riel@redhat.com>, "Dave Chinner" <david@fromorbit.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080529113159.113a7f06@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
	 <20080529113159.113a7f06@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Alan,

On 5/29/08, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > As a result, with LVM, you can never export a "logical volume" with
> > claimed storage space larger than of the underlying physical storage
> > devices (e.g. SATA disks, Hardware RAID array etc.); but with ASD, you
> > can export "logical volumes" which have much larger logical storage
> > space.
>
> Why do that ?
>
> > Does anyone have some ideas for a better solution?
>
> Take one file system such as ext3, or even a cluster file system like
> GFS2 or OCFS. Create top level subdirectories in it for each machine.
> Either export the subdirectory via NFS. Alternatively mount the clustered
> file system somewhere on each node and then remount the subdirectory into
> the right place in the file tree
>
> (And for a clustered/shared pool root you can use pivot_root() to start
> from initrd or local disk and then switch to running entirely within the
> clusterfs)

Thank you for your quick reply.

Yes, in our ASD system, we have implemented "Thin Provioning" on block
level, and we do have the problem of "no way to free space". Thank Rik
van Riel for pointing this out.

However, I want to ask, is there _any need_ to implement "Thin
Provioning" on block level rather than FS level?
In my opinon, there are some reasons why we implemented "Thin
Provioning" on block level:
1. We can use _all_ types of FS on our ASD device.
2. In our current system, we use some other virtual device drivers to
provide other features, like snapshot, cahce management, exporting as
an iSCSI target in a SAN, etc. Please note, all of these virtual
device drivers have been developed already.
3. Some storage vendors (e.g. EMC) have their own "Block-based thin
provisioning" product; they must have enough reasons to do so.
Please check the following URL for reference:
http://www.wikibon.org/Maximizing_storage_returns_from_your_EMC_relationship#Strategic_fit_for_EMC_in_key_storage_modernization_projects
Then search the string "Block-based thin provisioning".
