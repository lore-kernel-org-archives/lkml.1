Return-Path: <linux-kernel-owner+w=401wt.eu-S1752141AbZAaFER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141AbZAaFER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 00:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750765AbZAaFEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 00:04:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750715AbZAaFD7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 00:03:59 -0500
Date: Fri, 30 Jan 2009 21:03:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org, Holger Macht <hmacht@suse.de>,
       linux-acpi@vger.kernel.org
Subject: Re: mmotm 2009-01-28-02-17 uploaded - docking station issues.
Message-Id: <20090130210352.cf9e4d7f.akpm@linux-foundation.org>
In-Reply-To: <20830.1233246343@turing-police.cc.vt.edu>
References: <200901281019.n0SAJ9C6013727@imap1.linux-foundation.org>
	<20830.1233246343@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jan 2009 11:25:43 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Wed, 28 Jan 2009 02:19:09 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2009-01-28-02-17 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> % ls -l /sys/devices/platform/dock.0/docked
> -r--r--r-- 1 root root 4096 2009-01-29 10:49 /sys/devices/platform/dock.0/docked
> % cat /sys/devices/platform/dock.0/docked
> ñÞcat: write error: Bad address
> 
> strace of the cat shows:
> 
> open("/sys/devices/platform/dock.0/docked", O_RDONLY) = 3
> fstat(3, {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> read(3, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 4096) = 1812586496
> 
> Under 2.6.29-rc2-mmotm0116, this would return either "0" or "1", not 4K
> of nulls.
> 

Is it due to 

acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read.patch

and/or

acpi-dock-dont-eval-_sta-on-every-show_docked-sysfs-read-simplification.patch

?
