Return-Path: <linux-kernel-owner+w=401wt.eu-S1754282AbYE2KqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbYE2KqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 06:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYE2Kp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 06:45:56 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36567 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753168AbYE2Kpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 06:45:55 -0400
Date: Thu, 29 May 2008 11:31:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Xiaoming Li" <forrubm2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [help]How to block new write in a "Thin Provisioning" logical
 volume manager as a virtual device driver when physical spaces run out?
Message-ID: <20080529113159.113a7f06@core>
In-Reply-To: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
References: <5f7c1d2c0805290212i45aece46j7fae2dcf9c158b92@mail.gmail.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As a result, with LVM, you can never export a "logical volume" with
> claimed storage space larger than of the underlying physical storage
> devices (e.g. SATA disks, Hardware RAID array etc.); but with ASD, you
> can export "logical volumes" which have much larger logical storage
> space.

Why do that ?

> Does anyone have some ideas for a better solution?

Take one file system such as ext3, or even a cluster file system like
GFS2 or OCFS. Create top level subdirectories in it for each machine.
Either export the subdirectory via NFS. Alternatively mount the clustered
file system somewhere on each node and then remount the subdirectory into
the right place in the file tree

(And for a clustered/shared pool root you can use pivot_root() to start
from initrd or local disk and then switch to running entirely within the
clusterfs)

Alan

