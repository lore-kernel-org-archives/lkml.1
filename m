Return-Path: <linux-kernel-owner+w=401wt.eu-S1764664AbXHFMp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764664AbXHFMp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 08:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753775AbXHFMps
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 08:45:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:39924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbXHFMps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 08:45:48 -0400
Date: Mon, 6 Aug 2007 14:45:46 +0200
From: Olaf Hering <olh@suse.de>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       libc-alpha@sources.redhat.com
Subject: glibc and make headers_install_all provide /usr/include/scsi
Message-ID: <20070806124546.GA2117@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-DOS: I got your 640K Real Mode Right Here Buddy!
X-Homeland-Security: You are not supposed to read this line! You are a terrorist!
User-Agent: Mutt und vi sind doch schneller als Notes (und GroupWise)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


glibc and make headers_install_all provide /usr/include/scsi
One of them has to go.

A quick diff shows no differences, expect:

scsi.h:
     glibc #define STATUS_MASK          0x3e
     Linux #define STATUS_MASK          0xfe

     glibc #define ABORT               0x06
     Linux #define ABORT_TASK_SET      0x06

sg.h:struct sg_iovec ->sg_iovec
     unsigned char * in glibc
     void * in Linux

     glibc #define SG_DEFAULT_RETRIES 1
     Linux #define SG_DEFAULT_RETRIES 0


Which copy should be provided by a distributor?
