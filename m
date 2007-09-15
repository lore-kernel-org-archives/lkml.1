Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbXIOHp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbXIOHp1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Sep 2007 03:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXIOHpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Sep 2007 03:45:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:44679 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750872AbXIOHpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Sep 2007 03:45:19 -0400
Date: Sat, 15 Sep 2007 00:44:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: Two identical entries for "rtc" in /proc/devices
Message-Id: <20070915004421.33d552d3.akpm@linux-foundation.org>
In-Reply-To: <46E07DDA.2040907@redhat.com>
References: <46E07DDA.2040907@redhat.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Sep 2007 18:23:22 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:

> # ls -li
> total 0
> 4026532007 -r--r--r-- 1 root root 0 Sep  6 18:18 nvram
> 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> 4026532056 -rw-r--r-- 1 root root 0 Sep  6 18:18 snd-page-alloc

Next -mm has

procfs-detect-duplicate-names.patch
procfs-detect-duplicate-names-fix.patch
procfs-detect-duplicate-names-fix-fix-2.patch

which will at least tell us who the second offender is.

I have a vague memory that this is due to selecting two different types of
rtc in config.  Perhaps a Kconfig fix is needed, dunno.

