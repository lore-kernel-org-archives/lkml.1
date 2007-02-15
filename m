Return-Path: <linux-kernel-owner+w=401wt.eu-S1161026AbXBOTib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161026AbXBOTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 14:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161037AbXBOTib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 14:38:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60438 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161026AbXBOTia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 14:38:30 -0500
To: Juan Piernas Canovas <piernas@ditec.um.es>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, sfaibish <sfaibish@emc.com>,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] DualFS: File System with Meta-data and Data Separation
References: <op.tnkdlbgsrwwil4@brcsmondepl2c.corp.emc.com>
	<op.tnrbrocsunckof@usensfaibisl2e.eng.emc.com>
	<Pine.LNX.4.61.0702142251460.19368@yvahk01.tjqt.qr>
	<Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es>
From: Andi Kleen <andi@firstfloor.org>
Date: 15 Feb 2007 21:38:18 +0100
In-Reply-To: <Pine.LNX.4.61.0702151910370.19998@ditec.inf.um.es>
Message-ID: <p73sld7f96t.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Juan Piernas Canovas <piernas@ditec.um.es> writes:

[playing devil's advocate here]
 
> If the data and meta-data devices of DualFS can be on different disks,
> DualFS is able to READ and WRITE data and meta-data blocks in
> PARALLEL.

XFS can do this too using its real time volumes (which don't contain
any metadata).  It can also have a separate log.

Also many storage subsystems have some internal parallelism
in writing (e.g. a RAID can write on different disks in parallel for
a single partition) so i'm not sure your distinction is that useful.

If you stripe two disks with a standard fs versus use one of them
as metadata volume and the other as data volume with dualfs i would
expect the striped variant usually be faster because it will give
parallelism not only to data versus metadata, but also to all data
versus other data.

Also I would expect your design to be slow for metadata read intensive
workloads. E.g. have you tried to boot a root partition with dual fs?
That's a very important IO benchmark for desktop Linux systems.

-Andi
