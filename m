Return-Path: <linux-kernel-owner+w=401wt.eu-S1758822AbXK0R75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbXK0R75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 12:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757187AbXK0R7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 12:59:46 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46291 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756654AbXK0R7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 12:59:45 -0500
Date: Tue, 27 Nov 2007 12:50:07 -0500
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, mingo@elte.hu,
       kamalesh@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       apw@shadowen.org, balbir@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
       tglx@linutronix.de, clameter@sgi.com
Subject: Re: 2.6.24-rc3-mm1 - Kernel Panic on IO-APIC
Message-ID: <20071127125007.4e1eddff@bree.surriel.com>
In-Reply-To: <20071126152832.f6c808f3.akpm@linux-foundation.org>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org>
	<4743CC0B.9000508@linux.vnet.ibm.com>
	<20071120221839.faab108e.akpm@linux-foundation.org>
	<20071126143943.0a01665b@cuia.boston.redhat.com>
	<20071126123319.7483e57f.akpm@linux-foundation.org>
	<20071126204540.GA19874@elte.hu>
	<474B43E1.9080407@gmail.com>
	<20071126141713.3dcd492b.akpm@linux-foundation.org>
	<474B5349.2070500@gmail.com>
	<20071126152832.f6c808f3.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 15:28:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 27 Nov 2007 00:14:17 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
> > On 11/26/2007 11:17 PM, Andrew Morton wrote:
> > >> Maybe if you can emit a broken-out with the fresh pull to test?
> > > 
> > > http://userweb.kernel.org/~akpm/mmotm/ is current.  But it probably won't
> > > compile. 
> > 
> > Yes it did :). And it worked. Both in qemu and on my desktop...
> 
> boggle.  Let's slap 2.6.25 on it and take the rest of the year off.

No worries, the mmotm compiling issue seems to have been fixed:

  CC [M]  drivers/scsi/libsas/sas_ata.o
drivers/scsi/libsas/sas_ata.c:39: error: field ‘rphy’ has incomplete type
drivers/scsi/libsas/sas_ata.c: In function ‘sas_discover_sata’:
drivers/scsi/libsas/sas_ata.c:773: error: implicit declaration of function ‘ata_sas_rphy_alloc’
drivers/scsi/libsas/sas_ata.c:775: error: dereferencing pointer to incomplete type
drivers/scsi/libsas/sas_ata.c:775: warning: assignment makes pointer from integer without a cast
drivers/scsi/libsas/sas_ata.c:781: error: dereferencing pointer to incomplete type
drivers/scsi/libsas/sas_ata.c:782: error: dereferencing pointer to incomplete type
drivers/scsi/libsas/sas_ata.c:784: warning: type defaults to ‘int’ in declaration of ‘__mptr’
drivers/scsi/libsas/sas_ata.c:784: warning: initialization from incompatible pointer type
drivers/scsi/libsas/sas_ata.c:791: error: implicit declaration of function ‘ata_sas_rphy_add’
drivers/scsi/libsas/sas_ata.c:807: error: implicit declaration of function ‘ata_sas_rphy_delete’
drivers/scsi/libsas/sas_ata.c:809: error: implicit declaration of function ‘ata_sas_rphy_free’
make[3]: *** [drivers/scsi/libsas/sas_ata.o] Error 1
make[2]: *** [drivers/scsi/libsas] Error 2
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2

So much for continuing the bisect with that tree, to find the
cause of the second bug :)

Guess I'll extract an x86 tree changeset first, to place into
the 2.6.23-rc3-mm1 broken out tree and work from there...

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
