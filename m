Return-Path: <linux-kernel-owner+w=401wt.eu-S1758991AbXIBUeq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991AbXIBUeq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 16:34:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751228AbXIBUej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 16:34:39 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:39363 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989AbXIBUei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 16:34:38 -0400
Message-ID: <46DB1E5C.2080107@garzik.org>
Date: Sun, 02 Sep 2007 16:34:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Satyam Sharma <satyam@infradead.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alasdair G Kergon <agk@redhat.com>, dm-devel@redhat.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] drivers/md/: Shut up uninitialized variable warnings
References: <alpine.LFD.0.999.0709022344550.27844@enigma.security.iitk.ac.i n> <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
In-Reply-To: <alpine.LFD.0.999.0709030151320.29617@enigma.security.iitk.ac.in>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma wrote:
> drivers/md/dm-exception-store.c: In function ‘persistent_read_metadata’:
> drivers/md/dm-exception-store.c:452: warning: ‘new_snapshot’ may be used uninitialized in this function
> 
> drivers/md/dm-ioctl.c: In function ‘ctl_ioctl’:
> drivers/md/dm-ioctl.c:1407: warning: ‘param’ may be used uninitialized in this function
> 
> [ For these, I'd like to especially add -- shame on you, gcc! ]
> 
> drivers/md/dm-table.c: In function ‘dm_get_device’:
> drivers/md/dm-table.c:472: warning: ‘dev’ may be used uninitialized in this function
> 
> are all verified to be bogus warnings. Let's shut them up.
> 
> ---
> 
>  drivers/md/dm-exception-store.c |    3 ++-
>  drivers/md/dm-ioctl.c |    2 +-
>  drivers/md/dm-table.c |    2 +-
>  3 file changed, 4 insertions(+), 3 deletion(-)

same comment as with the last uninit'd var patch:  these markers should 
be used sparingly.  Try it on multiple compiler versions, see if it's a 
new behavior.

Quite realistically, you might actually be finding gcc bugs, implying 
the proper path is to file a gcc bug report (and they are _very_ 
diligent about handling these, its impressive) rather than to patch the 
Linux kernel.

Overall, for any uninitialized_var() patch, we need more info on 
platform/compiler version/analysis methods/etc.

	Jeff



