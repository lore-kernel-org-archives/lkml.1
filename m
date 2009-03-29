Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZC2QKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZC2QKl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 12:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZC2QKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 12:10:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:60137 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbZC2QKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 12:10:30 -0400
Date: Sun, 29 Mar 2009 09:11:48 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Thomas =?UTF-8?B?QsOkY2hsZXI=?= <thomas@archlinux.org>
Cc: linux-kernel@vger.kernel.org,
       Thomas =?UTF-8?B?QsOkY2hsZXI=?= <thomas@archlinux.org>
Subject: Re: fastboot/async and initramfs: How am I supposed to know when
 devices are finished initializing?
Message-ID: <20090329091148.16a618bf@infradead.org>
In-Reply-To: <49CF9BA1.5030400@archlinux.org>
References: <49CF9BA1.5030400@archlinux.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Mar 2009 18:02:41 +0200
Thomas Bächler <thomas@archlinux.org> wrote:

> Okay, I have this problem in 2.6.29 with the "fastboot" option and in 
> today's linux-2.6.git.
> 
> In initramfs, we run the following commands:
>      /sbin/udevd --daemon
>      /sbin/udevadm trigger
>      /sbin/udevadm settle
> Among other things, this loads the ata_piix on my machine. On older 
> kernels I could assume that after these commands, /dev/sda* existed

not if you have CONFIG_SCSI_SCAN_ASYNC set though..

> and I could immediately access them (in my case, I run cryptsetup on 
> /dev/sda6). But now, the devices don't exist here, but are only
> created a second or so later. As a result, the initramfs script has
> already bailed out as it couldn't find /dev/sda6 and assumed that the
> hard drive didn't exist.

the CONFIG_SCSI_WAIT_SCAN method (basically loading that module to wait
for the scans to finish) will work for you......


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
