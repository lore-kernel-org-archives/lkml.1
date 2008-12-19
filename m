Return-Path: <linux-kernel-owner+w=401wt.eu-S1753450AbYLSSbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450AbYLSSbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 13:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbYLSSbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 13:31:08 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:37334 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbYLSSbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 13:31:07 -0500
Message-ID: <494BE84E.4000201@oracle.com>
Date: Fri, 19 Dec 2008 10:30:38 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/14] kmemleak: Add documentation on the memory leak
 detector
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com> <20081219181307.7778.42984.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20081219181307.7778.42984.stgit@pc1117.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.494BE856.0122:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Catalin Marinas wrote:
> This patch adds the Documentation/kmemleak.txt file with some
> information about how kmemleak works.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---
>  Documentation/kernel-parameters.txt |    4 +
>  Documentation/kmemleak.txt          |  142 +++++++++++++++++++++++++++++++++++
>  2 files changed, 146 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/kmemleak.txt
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index e0f346d..7f5f642 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -1042,6 +1042,10 @@ and is between 256 and 4096 characters. It is defined in the file
>  			Configure the RouterBoard 532 series on-chip
>  			Ethernet adapter MAC address.
>  
> +	kmemleak=	[KNL] Boot-time kmemleak enable/disable
> +			Valid arguments: on, off
> +			Default: on
> +
>  	l2cr=		[PPC]
>  
>  	l3cr=		[PPC]
> diff --git a/Documentation/kmemleak.txt b/Documentation/kmemleak.txt
> new file mode 100644
> index 0000000..c84d91b
> --- /dev/null
> +++ b/Documentation/kmemleak.txt
> @@ -0,0 +1,142 @@
> +Kernel Memory Leak Detector
> +===========================
> +
> +Introduction
> +------------
> +
> +Kmemleak provides a way of detecting possible kernel memory leaks in a
> +way similar to a tracing garbage collector
> +(http://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29#Tracing_garbage_collectors),
> +with the difference that the orphan objects are not freed but only
> +reported via /sys/kernel/debug/kmemleak. A similar method is used by the
> +Valgrind tool (memcheck --leak-check) to detect the memory leaks in
> +user-space applications.
> +
> +Usage
> +-----
> +
> +CONFIG_DEBUG_KMEMLEAK in "Kernel hacking" has to be enabled. A kernel
> +thread scans the memory every 10 min (by default) and prints any new

                                    minutes

> +unreferenced objects found. To trigger an intermediate scan and display
> +all the possible memory leaks:

Looks good otherwise.  Thanks.

-- 
~Randy
