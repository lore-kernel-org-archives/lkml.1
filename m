Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYIROVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYIROVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbYIROVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:21:45 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40031 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701AbYIROVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:21:45 -0400
Date: Thu, 18 Sep 2008 10:04:16 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>,
       randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, akpm@linux-foundation.org, agk@sourceware.org,
       subrata@linux.vnet.ibm.com, axboe@kernel.dk,
       Marco Innocenti <m.innocenti@cineca.it>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
       ngupta@google.com
Subject: Re: [RFC][PATCH -mm 1/5] i/o controller documentation
Message-ID: <20080918140416.GF20640@redhat.com>
References: <1219853257-11052-2-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219853257-11052-2-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2008 at 06:07:33PM +0200, Andrea Righi wrote:
> Documentation of the block device I/O controller: description, usage,
> advantages and design.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  Documentation/controllers/io-throttle.txt |  377 +++++++++++++++++++++++++++++
>  1 files changed, 377 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/controllers/io-throttle.txt
> 
> diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
> new file mode 100644
> index 0000000..09df0af
> --- /dev/null
> +++ b/Documentation/controllers/io-throttle.txt
> @@ -0,0 +1,377 @@
> +
> +               Block device I/O bandwidth controller
> +
> +----------------------------------------------------------------------
> +1. DESCRIPTION
> +
> +This controller allows to limit the I/O bandwidth of specific block devices for
> +specific process containers (cgroups) imposing additional delays on I/O
> +requests for those processes that exceed the limits defined in the control
> +group filesystem.
> +
> +Bandwidth limiting rules offer better control over QoS with respect to priority
> +or weight-based solutions that only give information about applications'
> +relative performance requirements. Nevertheless, priority based solutions are
> +affected by performance bursts, when only low-priority requests are submitted
> +to a general purpose resource dispatcher.
> +
> +The goal of the I/O bandwidth controller is to improve performance
> +predictability from the applications' point of view and provide performance
> +isolation of different control groups sharing the same block devices.
> +
> +NOTE #1: If you're looking for a way to improve the overall throughput of the
> +system probably you should use a different solution.
> +
> +NOTE #2: The current implementation does not guarantee minimum bandwidth
> +levels, the QoS is implemented only slowing down I/O "traffic" that exceeds the
> +limits specified by the user; minimum I/O rate thresholds are supposed to be
> +guaranteed if the user configures a proper I/O bandwidth partitioning of the
> +block devices shared among the different cgroups (theoretically if the sum of
> +all the single limits defined for a block device doesn't exceed the total I/O
> +bandwidth of that device).
> +

Hi Andrea,

Had a query. What's your use case for capping max bandwidth? I was
wondering will proportional bandwidth not cover it. So if we allocate
weight/share to every cgroup and limit the bandwidth based on shares
only in case of contention. Otherwise applications get to unlimited
bandwidth. Much like what cpu controller does or for that matter dm-ioband
seems to be doing the same thing. Will you not get same kind of QoS here when
comapred to max-bandwidth. The only thing probably missing is what we call
hard limit. When BW is available but you don't want a user to use that
BW, until and unless user has paid for that.

Thanks
Vivek
