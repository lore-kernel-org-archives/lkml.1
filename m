Return-Path: <linux-kernel-owner+w=401wt.eu-S932537AbYGQVO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932537AbYGQVO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 17:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760272AbYGQVOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 17:14:19 -0400
Received: from xenotime.net ([66.160.160.81]:42962 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760233AbYGQVOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 17:14:18 -0400
Date: Thu, 17 Jul 2008 14:14:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: <Solofo.Ramangalahy@bull.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
       Matt Helsley <matthltc@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH -mm v2 3/3] sysv ipc: use auto_msgmnb to desactivate and
 reactivate msgmnb recomputation
Message-Id: <20080717141409.2edcb7be.rdunlap@xenotime.net>
In-Reply-To: <20080715211408.381111371@bull.net>
References: <20080715211407.423625725@bull.net>
	<20080715211408.381111371@bull.net>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008 23:14:10 +0200 Solofo.Ramangalahy@bull.net wrote:

> From: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> 
> Add /proc/sys/kernel/auto_msgmnb to control automatic recomputation of
> /proc/sys/kernel/msgmnb (msg_ctlmnb).
> 
> Signed-off-by: Solofo Ramangalahy <Solofo.Ramangalahy@bull.net>
> ---
>  Documentation/sysctl/kernel.txt |   35 ++++++++++++++++
>  include/linux/ipc_namespace.h   |    5 ++
>  ipc/ipc_sysctl.c                |   87 ++++++++++++++++++++++++++++++++++++----
>  ipc/ipcns_notifier.c            |   62 +++++++++++++++++++++++++++-
>  ipc/namespace.c                 |    2 
>  ipc/util.c                      |    1 
>  6 files changed, 183 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.26-rc8-mm1-MSGMNB3/Documentation/sysctl/kernel.txt
> ===================================================================
> --- linux-2.6.26-rc8-mm1-MSGMNB3.orig/Documentation/sysctl/kernel.txt
> +++ linux-2.6.26-rc8-mm1-MSGMNB3/Documentation/sysctl/kernel.txt
> @@ -179,6 +179,41 @@ kernel stack.
>  
>  ==============================================================
>  
> +msgmnb
> +
> +Maximum size in bytes, not in message count, of a single SystemV IPC
> +message queue (b stands for bytes).
> +
> +This value is dynamic and depends on the online cpu count of the
> +machine (taking cpu hotplug into account).

Prefer "CPU" to "cpu".

> +
> +Computed values are between MSGMNB and MSGMNB*MSG_CPU_SCALE #define
> +constants (currently [16384,65536]).
> +
> +The exact value is automatically (re)computed, but:
> +
> +. If the value is positioned from user space (via procfs or sysctl()),

s/positioned/specified/ or set

> +  then the automatic recomputation is disabled. E.g.:
> +
> +  # echo 16384 > /proc/sys/kernel/msgmnb
> +
> +. The automatic recomputation can also be disabled via auto_msgmnb,
> +  e.g.:
> +
> +  # echo 0 > /proc/sys/kernel/auto_msgmnb
> +
> +. When disabled, the automatic recomputation can be reenabled via
> +  auto_msgmnb, e.g.:
> +
> +  # echo 1 > /proc/sys/kernel/auto_msgmnb
> +
> +The msgmnb and auto_msgmnb values in each (ipc) namespace are
> +independent.
> +

Prefer IPC instead of ipc (above and below).

> +Initially, the msgmnb value is computed automatically: at boot time
> +and (ipc) namespace creation.
> +
> +==============================================================


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
