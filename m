Return-Path: <linux-kernel-owner+w=401wt.eu-S1759127AbZDKTQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759127AbZDKTQh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 15:16:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758661AbZDKTQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 15:16:28 -0400
Received: from mga07.intel.com ([143.182.124.22]:21736 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758377AbZDKTQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 15:16:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,172,1239001200"; 
   d="scan'208";a="130442046"
Message-ID: <49E0EC87.9080808@linux.intel.com>
Date: Sat, 11 Apr 2009 12:16:23 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Takashi Iwai <tiwai@suse.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] [2.6.30-rc1-git2 regressions] Hibernation broken and
 (minor but annoying) audio problem
References: <200904100057.43827.rjw@sisk.pl> <alpine.LFD.2.00.0904091605080.4583@localhost.localdomain> <200904101439.43480.rjw@sisk.pl> <alpine.LFD.2.00.0904102233330.8559@localhost.localdomain> <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904111109500.4583@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Fri, 10 Apr 2009, Len Brown wrote:
>> fastboot also causes the S3 regression here:
>>
>> http://bugzilla.kernel.org/show_bug.cgi?id=12936
> 
> Looks like the same issue. Does my one-liner fix that case too?
Now that I've been able to scan most of my mail; it looks like the one-liner should just go in.
Restricting module loading from async work to only non-blocking is not a big deal,
and it seems that userspace in various distros is really broken (and breaks on scsi already today),
but that is not something we can really fix quickly.
The sad part is that the userland is unlikely get fixed unless it shows breakage, and we can't break it (obviously).

I don't know of any good other solutions; right now it's mostly the partition scan (which is already mostly async on
scsi since a really long time, just in practice fast enough unless you have a big server).

(The __init thing in modules is separate and easy to fix, but without the other stuff being fixed there's no point)


