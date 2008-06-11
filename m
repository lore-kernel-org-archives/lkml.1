Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYFKWu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYFKWu4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYFKWus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:50:48 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:46008 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYFKWus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:50:48 -0400
Date: Wed, 11 Jun 2008 15:42:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] i/o bandwidth controller documentation
Message-Id: <20080611154228.ef269ff2.randy.dunlap@oracle.com>
In-Reply-To: <1212791250-32320-2-git-send-email-righi.andrea@gmail.com>
References: <1212791250-32320-2-git-send-email-righi.andrea@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  7 Jun 2008 00:27:28 +0200 Andrea Righi wrote:

> Documentation of the block device I/O bandwidth controller: description, usage,
> advantages and design.
> 
> Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
> ---
>  Documentation/controllers/io-throttle.txt |  150 +++++++++++++++++++++++++++++
>  1 files changed, 150 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/controllers/io-throttle.txt
> 
> diff --git a/Documentation/controllers/io-throttle.txt b/Documentation/controllers/io-throttle.txt
> new file mode 100644
> index 0000000..5373fa8
> --- /dev/null
> +++ b/Documentation/controllers/io-throttle.txt
> @@ -0,0 +1,150 @@
> +
> +               Block device I/O bandwidth controller
> +
> +1. Description
> +
> +This controller allows to limit the I/O bandwidth of specific block devices for
> +specific process containers (cgroups) imposing additional delays on I/O
> +requests for those processes that exceed the limits defined in the control
> +group filesystem.
> +
> +Bandwidth limiting rules offer better control over QoS with respect to priority
> +or weight-based solutions that only give information about applications'
> +relative performance requirements.
> +
> +The goal of the I/O bandwidth controller is to improve performance
> +predictability and QoS of the different control groups sharing the same block
> +devices.
> +
> +NOTE: if you're looking for a way to improve the overall throughput of the
> +system probably you should use a different solution.
> +
> +2. User Interface
> +
> +A new I/O bandwidth limitation rule is described using the file
> +blockio.bandwidth.
> +
> +The same file can be used to set multiple rules for different block devices
> +relatively to the same cgroup.

   relative

> +
> +The syntax is the following:
> +# /bin/echo DEVICE:BANDWIDTH > CGROUP/blockio.bandwidth
> +
> +- DEVICE is the name of the device the limiting rule is applied to,
> +- BANDWIDTH is the maximum I/O bandwidth on DEVICE allowed by CGROUP,
> +- CGROUP is the name of the limited process container.



Thanks.
---
~Randy
"'Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
