Return-Path: <linux-kernel-owner+w=401wt.eu-S1754296AbZCJXz7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296AbZCJXz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 19:55:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755334AbZCJXzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 19:55:46 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:7982 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614AbZCJXzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 19:55:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:newsgroups:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=yC57LQhrpJ/3KoN38SE8FmwBhH0sqC+gSiXIEiH/lTTYxdafzBV+/WwPcKFLDkGwFA
         us5JG4zRXePUm+TuOaVBWjwOdm2tGEnyYqwAXWV6kXlXcDR5ysKFT6RFl62AtG8WOgIM
         57BHbkTCso31n+nMurkpePofdaVomBgawWuzw=
Message-ID: <49B6FDF6.7000100@gmail.com>
Date: Tue, 10 Mar 2009 17:55:34 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: n0diamond@yahoo.co.jp
CC: linux-kernel@vger.kernel.org
Subject: Re: LIBATA told me it's broken
References: <20090310081325.25764.qmail@web4113.mail.ogk.yahoo.co.jp>
In-Reply-To: <20090310081325.25764.qmail@web4113.mail.ogk.yahoo.co.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norman Diamond wrote:
> Sorry the kernel is 2.6.24.3 but I can't use a newer one
> yet because TASKFILEs broke in newer ones.  This time I
> booted with kernel parameter hda=noprobe so the hard disk
> went to LIBATA instead of IDE.  The breakage shown below
> is in LIBATA.
> 
> If LIBATA is fixed in newer kernel versions please say. 
> If there's a version of Slax where LIBATA works then maybe
> I can recompile its kernel without IDE.

There have been a ton of changes in libata since 2.6.24, it's hard to 
say whether anything has changed along the way that would affect this. 
The easiest way to find out is to try a newer kernel.

> 
> struct sg_io_hdr sg_io;
> uint8_t cdb[16];
> uint8_t sense[32];
> uint8_t buffer[0x20000];  // length = 256 * 512
> memset(&sg_io, 0, sizeof sg_io);
> memset(&cdb, 0, sizeof cdb);
> memset(&sense, 0, sizeof sense);
> memset(&buffer, 0xe5, sizeof buffer);
> cdb[0] = 0x8a;            // WRITE (16)
> cdb[6] = 0x0f;
> cdb[7] = 0xff;
> cdb[8] = 0xff;
> cdb[9] = 0x00;            // start = 0x0fffff00
> cdb[12] = 0x01;
> cdb[13] = 0x00;           // count = 0x0100
> sg_io.interface_id = 'S';
> sg_io.cmdp = cdb;
> sg_io.cmd_len = sizeof cdb;
> sg_io.dxferp = buffer;
> sg_io.dxfer_len = 256 * 512;
> sg_io.dxfer_direction = SG_DXFER_TO_DEV;
> sg_io.sbp = sense;
> sg_io.mx_sb_len = sizeof sense;
> sg_io.timeout = 2000;
> fd = open("/dev/sda", O_WRONLY);  // succeeded
> ioctl(fd, SG_IO, &sg_io);         // ioctl succeeded
>                                   // but LIBATA failed
> 
> CHECK CONDITION
> sense:
> 72 0b 14 00 00 00 00 0c 00 0a 80 00 00 00 00 00
> 0f ff ff 00

Anything in dmesg?

> 
> /dev/sda is a 250GB SATA drive but Dell's Intel ICH7M
> presents it as ATA.  Ranges before and after the magic
> LBA28 boundary wrote perfectly.
> 
> 
> 
> --------------------------------------
> Power up the Internet with Yahoo! Toolbar.
> http://pr.mail.yahoo.co.jp/toolbar/

