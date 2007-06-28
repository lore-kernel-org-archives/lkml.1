Return-Path: <linux-kernel-owner+w=401wt.eu-S1759996AbXF1Nt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759996AbXF1Nt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 09:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbXF1NtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 09:49:20 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:27011 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbXF1NtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 09:49:20 -0400
Date: Thu, 28 Jun 2007 15:49:19 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, arjan@infradead.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       schilling@fokus.fraunhofer.de, Ulrich Drepper <drepper@gmail.com>
Subject: Re: Linux Kernel include files
In-Reply-To: <20070627171812.GA31705@uranus.ravnborg.org>
Message-ID: <Pine.LNX.4.64.0706281546340.22579@fbirervta.pbzchgretzou.qr>
References: <46826d13.44vmeDzVCWEJhtNJ%Joerg.Schilling@fokus.fraunhofer.de>
 <20070627171812.GA31705@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 27 2007 19:18, Sam Ravnborg wrote:
>
>For my test I used latest -git of the Linux kernel.
>In this version the include of ext2_fs_bh.h is guarded
>by __KERNEL__ like this:
>
>#ifdef __KERNEL__
>#include <linux/ext2_fs_sb.h>
>static inline struct ext2_sb_info *EXT2_SB(struct super_block *sb)
>{
>        return sb->s_fs_info;
>}
[...]

I'll have to chime in here.
Test program:
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <linux/in.h> /* get IP_FREEBIND */

Creates a lot of error messages.
(Lots of redefinitions.)

$ rpm -q linux-kernel-headers glibc
linux-kernel-headers-2.6.21-7
glibc-2.6-5
(suse 10.3 factory)

So looks like there's still something to do.



	Jan
-- 
