Return-Path: <linux-kernel-owner+w=401wt.eu-S1757513AbXI2SCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757513AbXI2SCe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 14:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbXI2SC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 14:02:27 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62325 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbXI2SC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 14:02:26 -0400
Date: Sat, 29 Sep 2007 11:01:29 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Kok, Auke" <auke-jan.h.kok@intel.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Jan Engelhardt <jengelh@computergmbh.de>, Adrian Bunk <bunk@kernel.org>,
       roel <12o3l@tiscali.nl>
Subject: Re: [PATCH 1/3] CodingStyle updates
Message-Id: <20070929110129.307cbd9f.randy.dunlap@oracle.com>
In-Reply-To: <11910151223447-git-send-email-ezk@cs.sunysb.edu>
References: <11910151223214-git-send-email-ezk@cs.sunysb.edu>
	<11910151223447-git-send-email-ezk@cs.sunysb.edu>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 17:32:00 -0400 Erez Zadok wrote:

> 1. Updates chapter 13 (printing kernel messages) to expand on the use of
>    pr_debug()/pr_info(), what to avoid, and how to hook your debug code with
>    kernel.h.
> 
> Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
> ---
>  Documentation/CodingStyle |   88 +++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 86 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
> index 7f1730f..00b29e4 100644
> --- a/Documentation/CodingStyle
> +++ b/Documentation/CodingStyle
> @@ -643,8 +643,26 @@ Printing numbers in parentheses (%d) adds no value and should be avoided.
>  There are a number of driver model diagnostic macros in <linux/device.h>
>  which you should use to make sure messages are matched to the right device
>  and driver, and are tagged with the right level:  dev_err(), dev_warn(),
> -dev_info(), and so forth.  For messages that aren't associated with a
> -particular device, <linux/kernel.h> defines pr_debug() and pr_info().
> +dev_info(), and so forth.
> +
> +A number of people often like to define their own debugging printf's,
> +wrapping printk's in #ifdef's that get turned on only when subsystem
> +debugging is compiled in (e.g., dprintk, Dprintk, DPRINTK, etc.).  Please
> +don't reinvent the wheel but use existing mechanisms.  For messages that
> +aren't associated with a particular device, <linux/kernel.h> defines
> +pr_debug() and pr_info(); the latter two translate to printk(KERN_DEBUG) and
> +printk(KERN_INFO), respectively.  However, to get pr_debug() to actually
> +emit the message, you'll need to turn on DEBUG in your code, which can be
> +done as follows in your subsystem Makefile:
> +
> +ifeq ($(CONFIG_WHATEVER_DEBUG),y)
> +EXTRA_CFLAGS += -DDEBUG
> +endif

Alternatively, that can be done in your source file, but doing this
in the Makefile makes good sense if you have more than one source file.
At any rate, it is done in some source files, and when it's done in
source files, #define-ing DEBUG should be done before #include
<linux/kernel.h> so that the macros are defined as expected.


> +In this way, you can create a Kconfig parameter to turn on debugging at
> +compile time, which will also turn on DEBUG, to enable pr_debug() to emit
> +actual messages; conversely, when CONFIG_WHATEVER_DEBUG is off, DEBUG is
> +off, and pr_debug() will display nothing.
>  
>  Coming up with good debugging messages can be quite a challenge; and once
>  you have them, they can be a huge help for remote troubleshooting.  Such

---
~Randy
Phaedrus says that Quality is about caring.
