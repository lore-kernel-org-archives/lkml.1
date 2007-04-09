Return-Path: <linux-kernel-owner+w=401wt.eu-S965654AbXDIPmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965654AbXDIPmN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 11:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965655AbXDIPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 11:42:13 -0400
Received: from iriserv.iradimed.com ([72.242.190.170]:49400 "EHLO iradimed.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965654AbXDIPmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 11:42:13 -0400
Message-ID: <461A5F13.7040705@cfl.rr.com>
Date: Mon, 09 Apr 2007 11:43:15 -0400
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Add a norecovery option to ext3/4?
References: <20070409000556.GA13980@implementation>
In-Reply-To: <20070409000556.GA13980@implementation>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Apr 2007 15:43:07.0870 (UTC) FILETIME=[C52B37E0:01C77ABD]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15106.000
X-TM-AS-Result: No--7.027500-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> Distribution installers usually try to probe OSes for building a suited
> grub menu.  Unfortunately, mounting an ext3 partition, even in read-only
> mode, does perform some operations on the filesystem (log recovery).
> This is not a good idea since it may silently garbage data.  XFS has a
> norecovery option that allows to disable that, I'd say ext3/4 should
> have it too.

When the filesystem is told to mount the disk read only, that means it 
should not write to it.  The fact that ext3 goes ahead and does anyway 
is a bug and should be fixed.  There is no need for a norecovery option, 
because read only is a sufficient directive to tell the filesystem not 
to write to the disk.

As someone else pointed out, this behavior causes havoc if you hibernate 
a system and then boot up another system which mounts the disk of the 
hibernated system.  Under all conditions it should be safe to mount a 
disk read only, but here it is not because the journal playback trashes 
the disk out from under the hibernated system.


