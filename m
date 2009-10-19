Return-Path: <linux-kernel-owner+w=401wt.eu-S1757425AbZJSTvl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757425AbZJSTvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 15:51:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757361AbZJSTvk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 15:51:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZJSTvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 15:51:40 -0400
Date: Mon, 19 Oct 2009 17:51:28 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Glauber Costa <glommer@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, avi@redhat.com
Subject: Re: [PATCH] v5: allow userspace to adjust kvmclock offset
Message-ID: <20091019195128.GC17781@amt.cnet>
References: <1255721316-11777-1-git-send-email-glommer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1255721316-11777-1-git-send-email-glommer@redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 03:28:36PM -0400, Glauber Costa wrote:
> When we migrate a kvm guest that uses pvclock between two hosts, we may
> suffer a large skew. This is because there can be significant differences
> between the monotonic clock of the hosts involved. When a new host with
> a much larger monotonic time starts running the guest, the view of time
> will be significantly impacted.
> 
> Situation is much worse when we do the opposite, and migrate to a host with
> a smaller monotonic clock.
> 
> This proposed ioctl will allow userspace to inform us what is the monotonic
> clock value in the source host, so we can keep the time skew short, and
> more importantly, never goes backwards. Userspace may also need to trigger
> the current data, since from the first migration onwards, it won't be
> reflected by a simple call to clock_gettime() anymore.
> 
> [ v2: uses a struct with a padding ]
> [ v3: provide an ioctl to get clock data too ]
> [ v4: used fixed-width signed type for delta ]
> [ v5: nitpick fixes, documentation update, and capability bit ]
> 
> Signed-off-by: Glauber Costa <glommer@redhat.com>

Applied, thanks (the ioctl number changed though).
