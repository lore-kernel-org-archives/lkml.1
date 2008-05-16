Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbYEPVpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbYEPVpf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 17:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYEPVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 17:45:25 -0400
Received: from mail2.shareable.org ([80.68.89.115]:60031 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYEPVpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 17:45:24 -0400
Date: Fri, 16 May 2008 22:45:16 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/4] (RESEND) ext3[34] barrier changes
Message-ID: <20080516214516.GA15334@shareable.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <482DDA56.6000301@redhat.com> <20080516130545.845a3be9.akpm@linux-foundation.org> <482DF44B.50204@redhat.com> <20080516135814.1c973bd5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080516135814.1c973bd5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> > I suppose alternately I could send another patch to remove "remember
> > that ext3/4 by default offers higher data integrity guarantees than
> > most." from Documentation/filesystems/ext4.txt  ;)
> 
> We could add a big scary printk at mount time and provide a document?

Can I suggest making /proc/mounts say "barrier=0" when journal is not
enabled, instead of omitting the option.

Boot logs are too large to pay close attention to unless it's really
obvious.  (2.4 kernels _do_ have a similar message about "data
integrity not guaranteed" with USB drivers - I never understood what
it was getting it, and why it was removed for 2.6).

However, if I saw barrier=0 in /proc/mounts it would at least prompt
me to look it up and then making an informed decision.

Personally I had assumed barriers were enabled by default with ext3,
as some distros do that, the 2.4 patches did that, and:

   I *have* experienced corruption following power loss without
   barriers, and none with barriers.

   When I mentioned that turning off write cache or using barriers is
   a solution to a programmer working on the same project, she said
   "oh, yes, we've had reports of disk corruption too - thanks for the
   advice", and the advice worked, so I am not the only one.

   (In the interests of perspective, that's with ext3 on patched 2.4
   kernels on a ARM device, but still - the barriers seem to work).

On a related note, there is advice floating about the net to run with
IDE write cache turned off if you're running a database and care about
integrity.  That has much worse performance than barriers.

I guess the patch which fixes fsync is particularly useful for those
database users, as it means they can run with write cache enabled and
depend on fsync() to give equivalent integrity now.  (Enabling
journalling is not really relevant to this).

-- Jamie

