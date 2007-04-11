Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXDKWgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXDKWgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 18:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161306AbXDKWgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 18:36:11 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57776 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161276AbXDKWgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 18:36:09 -0400
Date: Wed, 11 Apr 2007 23:39:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pedro <linux_user@izecksohn.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: tmpfs and the OOM killer
Message-ID: <20070411233921.7a5c3cff@the-village.bc.nu>
In-Reply-To: <200704111927.00609.linux_user@izecksohn.com>
References: <200704110223.31291.linux_user@izecksohn.com>
	<20070411194820.GI943@1wt.eu>
	<200704111927.00609.linux_user@izecksohn.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>   2) How should an application be written to not be killed by OOM?

OOM isn't an application matter. The kernel has to choose between
allowing overcommit on the basis it might run out of memory and have to
kill stuff, or that it won't in which case an applicatio which correctly
handles malloc() and similar failures will not be killed (unless it is
out of space on a stack grow which is a C language flaw as you can't
catch that event in C)

It's configured by /proc/sys/vm/overcommit_memory

0 - try and spot obviously dumb allocations
1 - anything goes
2 - strictly control resource commit
