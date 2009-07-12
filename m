Return-Path: <linux-kernel-owner+w=401wt.eu-S1753304AbZGLTej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbZGLTej (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 15:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751071AbZGLTe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 15:34:29 -0400
Received: from mail-yx0-f184.google.com ([209.85.210.184]:55743 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbZGLTe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 15:34:29 -0400
Message-ID: <4A5A3AC1.5080800@codemonkey.ws>
Date: Sun, 12 Jul 2009 14:34:25 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Schwidefsky <schwidefsky@de.ibm.com>, chris.mason@oracle.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <a09e4489-a755-46e7-a569-a0751e0fc39f@default> <4A5A1A51.2080301@redhat.com>
In-Reply-To: <4A5A1A51.2080301@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
>
> In fact CMM2 is much more intrusive (but on the other hand provides 
> much more information).
I don't think this will remain true long term.  CMM2 touches a lot of 
core mm code and certainly qualifies as intrusive.  However the result 
is that the VMM has a tremendous amount of insight into how the guest is 
using it's memory and can implement all sorts of fancy policy for 
reclaim.  Since the reclaim policy can evolve without any additional 
assistance from the guest, the guest doesn't have to change as policy 
evolves.

Since tmem requires that reclaim policy is implemented within the guest, 
I think in the long term, tmem will have to touch a broad number of 
places within Linux.  Beside the core mm, the first round of patches 
already touch filesystems (just ext3 to start out with).  To truly be 
effective, tmem would have to be a first class kernel citizen and I 
suspect a lot of code would have to be aware of it.

So while CMM2 does a lot of code no one wants to touch, I think in the 
long term it would remain relatively well contained compared to tmem 
which will steadily increase in complexity within the guest.

Regards,

Anthony Liguori
