Return-Path: <linux-kernel-owner+w=401wt.eu-S1756456AbXKENSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756456AbXKENSn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 08:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754967AbXKENSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 08:18:35 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:33977 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754803AbXKENSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 08:18:34 -0500
Date: Mon, 5 Nov 2007 14:18:19 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Michael Holzheu <holzheu@de.ibm.com>
Subject: Re: [PATCH 27/54] kset: convert s390 hypervisor kset to use
 kset_create
Message-ID: <20071105141819.22af5f6f@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1194047972-9850-27-git-send-email-gregkh@suse.de>
References: <20071102235758.GA9803@kroah.com>
	<1194047972-9850-27-git-send-email-gregkh@suse.de>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Nov 2007 16:59:05 -0700,
Greg Kroah-Hartman <gregkh@suse.de> wrote:

> Dynamically create the kset instead of declaring it statically.
> 
> Cc: Kay Sievers <kay.sievers@vrfy.org>
> Cc: Michael Holzheu <holzheu@de.ibm.com>
> Cc: Cornelia Huck <cornelia.huck@de.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  arch/s390/hypfs/inode.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)

arch/s390/hypfs/inode.c: In function 'hypfs_init':
arch/s390/hypfs/inode.c:512: error: implicit declaration of function 'IS_PTR'

Signed-off-by: Cornelia Huck <cornelia.huck@de.ibm.com>
---
 arch/s390/hypfs/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/s390/hypfs/inode.c
===================================================================
--- linux-2.6.orig/arch/s390/hypfs/inode.c	2007-11-05 11:12:49.000000000 +0100
+++ linux-2.6/arch/s390/hypfs/inode.c	2007-11-05 14:14:46.000000000 +0100
@@ -509,7 +509,7 @@ static int __init hypfs_init(void)
 
 	s390_kset = kset_create_and_register("s390", NULL, NULL,
 		    hypervisor_kset);
-	if (IS_PTR(s390_kset)) {
+	if (IS_ERR(s390_kset)) {
 		rc = PTR_ERR(s390_kset);
 		goto fail_sysfs;
 	}
