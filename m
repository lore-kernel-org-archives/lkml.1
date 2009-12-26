Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZLZVHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZLZVHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 16:07:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751322AbZLZVHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 16:07:31 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46198 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbZLZVHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 16:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=XxdA/etZnPLdrFzclMGW89F6SuRVr2mUmmeVIFYx4kKCg5kNlFEALoyx4VXTjbJKpV
         k0PvS/+NmHAiO1FgDKrOZ3lNQiKCdilBNafYLj8Htv57IV54n7+sgQgJOrX3zoi9n/fd
         I5aKHDELBtzHWmtqQNM8iDgMBX/QredSP2mAU=
MIME-Version: 1.0
In-Reply-To: <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-3-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-4-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-5-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-6-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-7-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-8-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-9-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-10-git-send-email-jason.wessel@windriver.com> 
	<1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 26 Dec 2009 16:07:10 -0500
Message-ID: <8bd0f97a0912261307t44d27b4eyf238b3a794e6862@mail.gmail.com>
Subject: Re: [PATCH 10/37] kgdb: Make mem access function weak in kgdb.c and 
	kgdb.h
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com, mingo@elte.hu, Sonic Zhang <sonic.adi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 16:19, Jason Wessel wrote:
> L1 instruction memory and MMR memory on blackfin can not be accessed by
> common functions probe_kernel_read() and probe_kernel_write().
> Blackfin asks for 2/4 byte align access to MMR memory and DMA access to
> L1 instruction memory. These functions need to be reimplemented in
> architecture specific kgdb.c. Update documentation and prototypes as
> well.

considering these functions were made weak only because of
probe_kernel_(read|write), then perhaps it makes more sense to move
the work there.  it would mean that all consumers of these functions
work properly instead of just kgdb.

probe_kernel_write is already weak ... we just need to add weak to
probe_kernel_read i think, and make the functions available via a
"default" symbol so that arch overrides can tail back into the common
code when it makes sense.
-mike
