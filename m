Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYDTKan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYDTKan (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 06:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756527AbYDTKae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 06:30:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:29993 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198AbYDTKac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 06:30:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EuLZdvDGQJq3Q2VWhChfdk1uerI5qAUpdEEIJmquNansI0v4ORdM99KRdoBpzAQnhEFN4Lth4nvSJ1oa51dpIuIrITa/bqJldDNLU9eWZdYUKCOGTmf30XGFPBkGAGStKqurln7vctNj438QERgYkQ6vGrsEmuPgTDX6X1/pQ8I=
Date: Sun, 20 Apr 2008 15:25:49 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Sid Boyce <g3vbv@blueyonder.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-git1/2 not seeing /dev/sda1 (XFS root) or /dev/sda2
	(swap) partitions on a SATA drive
Message-ID: <20080420112549.GB4902@martell.zuzino.mipt.ru>
References: <480A9C1E.8050505@blueyonder.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <480A9C1E.8050505@blueyonder.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 02:27:58AM +0100, Sid Boyce wrote:
> 2.6.25 x86_64 boots fine as does -git1/2 boxes using reiserfs and ext3. 
> With xfs it can't find these and drops into a shell.
> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part2 swap        
>       swap       defaults              0 0
> /dev/disk/by-id/scsi-SATA_WDC_WD5000AAKS-_WD-WCAS85018679-part1 /           
>    xfs        defaults              1 1
>
> From my .config
> CONFIG_XFS_FS=m
> CONFIG_XFS_QUOTA=y
> CONFIG_XFS_POSIX_ACL=y
> CONFIG_XFS_RT=y
>
> The other boxes are configure pretty much the same, but I can diff the 
> .config's if required.
> # l /lib/modules/2.6.25-git2-smp/kernel/drivers/ata/sata_sil.ko
> -rw-r--r-- 1 root root 272240 2008-04-19 21:54 
> /lib/modules/2.6.25-git2-smp/kernel/drivers/ata/sata_sil.ko
>
> 00:0c.0 IDE interface: nVidia Corporation MCP55 IDE (rev a1)
> 00:0d.0 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> 00:0d.1 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> 00:0d.2 IDE interface: nVidia Corporation MCP55 SATA Controller (rev a2)
> 03:00.0 Mass storage controller: Silicon Image, Inc. SiI 3132 Serial ATA 
> Raid II Controller (rev 01)
>
> From working 2.6.25
> # lsmod|grep sata
> sata_nv                36872  2
> sata_sil24             26692  0
> libata                173664  3 pata_amd,sata_nv,sata_sil24

Double check that you've enabled CONFIG_ATA_SFF and then check you
previous CONFIG_SATA_* options.

