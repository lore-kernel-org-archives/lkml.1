Return-Path: <linux-kernel-owner+w=401wt.eu-S1752360AbZDLS1x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752360AbZDLS1x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 14:27:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750730AbZDLS1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 14:27:43 -0400
Received: from mga07.intel.com ([143.182.124.22]:9510 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750745AbZDLS1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 14:27:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,176,1239001200"; 
   d="scan'208";a="130613217"
Message-ID: <49E23298.5050702@linux.intel.com>
Date: Sun, 12 Apr 2009 11:27:36 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, Takashi Iwai <tiwai@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904111253520.4583@localhost.localdomain> <49E0F805.2090502@linux.intel.com> <200904122006.57425.rjw@suse.com>
In-Reply-To: <200904122006.57425.rjw@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> 
> OK, updated patch follows, with a changelog.
> 
> I've added this check to user.c too, because that code can be called
> independently of the one in disk.c .  Also, if resume is user space-driven,
> it's a good idea to wait for all of the device probes to complete before
> continuing.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM/Hibernate: Wait for SCSI devices scan to complete during resume
> 
> There is a race between resume from hibernation and the asynchronous
> scanning of SCSI devices and to prevent it from happening we need to
> call scsi_complete_async_scans() during resume from hibernation.
> 
> In addition, if the resume from hibernation is userland-driven, it's
> better to wait for all device probes in the kernel to complete before
> attempting to open the resume device.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

looks like a good fix to me (regardless of the async stuff)

Acked-by: Arjan van de Ven <arjan@linux.intel.com>
