Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbXFMH5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbXFMH5z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 03:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXFMH5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 03:57:48 -0400
Received: from mail.ipcas.de ([83.236.147.227]:36445 "EHLO mail.ipcas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756012AbXFMH5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 03:57:48 -0400
X-Greylist: delayed 1644 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jun 2007 03:57:47 EDT
Date: Wed, 13 Jun 2007 09:30:22 +0200
From: =?UTF-8?Q?Michael_K=C3=B6nig?= <Michael.Koenig@ipcas.de>
To: linux-kernel@vger.kernel.org
Subject: CRAMFS: Possible problem with named pipes
Message-ID: <132FF90BD68D10CCD22AE5F7@franken3>
X-Mailer: Mulberry/4.0.6 (Win32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I'm using Linux on a device with an ETRAX100LX utilizing SDK 2.10 fom Axis, 
which includes Linux 2.6.19.
I tried to use the latest CRAMFS code from the GIT repository, but I get 
the following error:
fs/cramfs/inode.c: In function `cramfs_readdir':
fs/cramfs/inode.c:342: structure has no member named `f_path'

I hope the behaviour is also reproducable with the latest code. 
Unfortunately I'm not sure which revision the code in the Axis distribution 
has, since there is no information in the source files.

To reproduce the problem follow these steps:
1. Create two named pipes on a CRAMFS image (in my case "fifo1" and 
"fifo2").
2. Output the pipes on separate terminals with "cat fifo1" and "cat fifo2".
3. Pipe a large text file (around 1MiB) into one of the pipes "cat 
large.txt > fifo1"

The result of these steps should be that some parts of the text file are 
piped to fifo1 while other parts are piped to fifo2.

I'm no kernel nor file system expert, but since pipes should be handled in 
the VFS but the inodes are provided by the file system (as far as I 
understand), this could be an inode mixup regarding named pipes in the 
CRAMFS.

Thanks in advance for any hints that might clear up this issue.

-- 
Mit freundlichen Grüßen
Best regards
Michael König

ipcas GmbH
Wetterkreuz 17
91058 Erlangen, Germany
Tel.: +49 9131 7677-31
Fax: +49 9131 7677-78
mailto:Michael.Koenig@ipcas.de

Geschäftsführer: Dipl.-Ing. S. Sutiono
Sitz der Gesellschaft: Erlangen
Registergericht: Fürth, HBR 3676
WEEE-Reg.-Nr. DE 77202473

Hinweis: Diese E-Mail und etwaige Anlagen können Betriebs- oder
Geschäftsgeheimnisse, dem Anwaltsgeheimnis unterliegen oder sonstige
vertrauliche Informationen enthalten. Sollten Sie diese E-Mail
irrtümlich erhalten haben, ist Ihnen der Status dieser E-Mail bekannt.
Bitte benachrichtigen Sie uns in diesem Fall sofort durch Antwort-Mail
und löschen Sie diese E-Mail nebst etwaigen Anlagen von Ihrem System.
Ebenso dürfen Sie diese E-Mail oder seine Anlagen
nicht kopieren oder an Dritte weitergeben. Vielen Dank.

