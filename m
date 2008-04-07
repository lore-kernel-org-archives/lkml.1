Return-Path: <linux-kernel-owner+w=401wt.eu-S1758131AbYDGPUv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131AbYDGPUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 11:20:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbYDGPUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 11:20:43 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54097 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbYDGPUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 11:20:42 -0400
Subject: Re: Trouble compiling kvm.git
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Balaji Rao <balajirrao@gmail.com>
Cc: Ke Wei <kewei@marvell.com>, linux-kernel@vger.kernel.org
In-Reply-To: <200804072037.08069.balajirrao@gmail.com>
References: <200804072037.08069.balajirrao@gmail.com>
Content-Type: text/plain
Date: Mon, 07 Apr 2008 10:20:36 -0500
Message-Id: <1207581636.3838.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-04-07 at 20:37 +0530, Balaji Rao wrote:
> Hi,
> 
> I had trouble compiling kvm.git.
> 
>   LD      drivers/scsi/built-in.o
> drivers/scsi/mvsas.o: In function `sas_ata_init_host_and_port':
> /kernels/git/kvm/include/scsi/sas_ata.h:50: multiple definition of `sas_ata_init_host_and_port'
> drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:50: first defined here
> drivers/scsi/mvsas.o: In function `sas_ata_task_abort':
> /kernels/git/kvm/include/scsi/sas_ata.h:54: multiple definition of `sas_ata_task_abort'
> drivers/scsi/libsas/built-in.o:/kernels/git/kvm/include/scsi/sas_ata.h:54: first defined here
> make[2]: *** [drivers/scsi/built-in.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2

Actually, the problem is a long standing one.  The fix is in scsi-misc:

http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commit;h=6bd758961524129d2ad0163001681ebc2c7809e4

The work around is to compile SCSI as a module or not include mvsas.

James


