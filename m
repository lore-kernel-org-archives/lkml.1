Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbZKIV3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbZKIV3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 16:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbZKIV3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 16:29:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56794 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754143AbZKIV3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 16:29:32 -0500
Date: Mon, 9 Nov 2009 13:28:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, device@lanana.org, rubini@vision.unipv.it,
       gregkh@suse.de, cluster-devel@redhat.com
Subject: Re: [PATCH] misc: use a proper range for minor number dynamic
 allocation
Message-Id: <20091109132836.6cf7f559.akpm@linux-foundation.org>
In-Reply-To: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
References: <1256340497-19320-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Oct 2009 21:28:17 -0200
Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:

> The current dynamic allocation of minor number for misc devices has some
> drawbacks.
> 
> First of all, the range for dynamic numbers include some statically
> allocated numbers. It goes from 63 to 0, and we have numbers in the
> range from 1 to 15 already allocated. Although, it gives priority to the
> higher and not allocated numbers, we may end up in a situation where we
> must reject registering a driver which got a static number because a
> driver got its number with dynamic allocation. Considering fs/dlm/user.c
> allocates as many misc devices as lockspaces are created, and that we
> have more than 50 users around, it's not unreasonable to reach that
> situation.

What is this DLM behaviour of which you speak?  It sounds broken.

> The proposed solution uses the not yet reserved range from 64 to 127. If
> more devices are needed, we may push 64 to 16. Moreover, if we don't
> need to give priority to the higher numbers anymore, we can start using
> the bitmap/bitops functions.

So...  misc minors 64 to 127 are presently unused?

> Finally, if there's a failure creating the device (because there's
> already one with the same name, for example), the current implementation
> does not clear the bit for the allocated minor and that number is lost
> for future allocations.
> 

Is that a bugfix for the existing code?

If so, please split that out into a separate patch which we can review
and apply promptly while we consider the broader problem which you've
identified.


