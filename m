Return-Path: <linux-kernel-owner+w=401wt.eu-S1757136AbXLJL6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136AbXLJL6p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbXLJL6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:58:38 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:49426 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbXLJL6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:58:37 -0500
Date: Mon, 10 Dec 2007 13:00:26 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>,
       Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
       davem@davemloft.net, mathieu.desnoyers@polymtl.ca,
       hskinnemoen@atmel.com
Subject: Re: [PATCH 2/2] Kprobes: Build kretprobe samples only if arch supports kretprobes
Message-ID: <20071210120026.GA14992@uranus.ravnborg.org>
References: <20071210095221.GA19425@in.ibm.com> <20071210095350.GB19425@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071210095350.GB19425@in.ibm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2007 at 03:23:50PM +0530, Ananth N Mavinakayanahalli wrote:
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> This patch builds samples/kprobes/kretprobe_example.c only on archs that
> support kretprobes.
> 
> 
> Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> ---
>  samples/kprobes/Makefile |    7 +++++--
>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.24-rc4/samples/kprobes/Makefile
> ===================================================================
> --- linux-2.6.24-rc4.orig/samples/kprobes/Makefile
> +++ linux-2.6.24-rc4/samples/kprobes/Makefile
> @@ -1,5 +1,8 @@
>  # builds the kprobes example kernel modules;
>  # then to use one (as root):  insmod <module_name.ko>
>  
> -obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o \
> -		kretprobe_example.o
> +obj-$(CONFIG_SAMPLE_KPROBES) += kprobe_example.o jprobe_example.o
> +
> +ifeq ($(CONFIG_HAVE_KRETPROBES),y)
> +obj-$(CONFIG_SAMPLE_KPROBES) += kretprobe_example.o
> +endif

It would be nice to push this configuration dependency to Kconfig.
Something like:

config SAMPLE_KRETPROBES
	default y
	depends on SAMPLE_KPROBES

And then in the Makefile have:
obj-$(CONFIG_SAMPLE_KRETPROBES) += kretprobe_example.o


	Sam
