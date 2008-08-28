Return-Path: <linux-kernel-owner+w=401wt.eu-S1756922AbYH1Tjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbYH1Tjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 15:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYH1TjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 15:39:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756660AbYH1TjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 15:39:18 -0400
Date: Thu, 28 Aug 2008 12:38:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel1@cyberdogtech.com
Cc: bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Bugme-new] [Bug 11446] New: Automate "to compile as module"
 strings
Message-Id: <20080828123847.dfc8943b.akpm@linux-foundation.org>
In-Reply-To: <bug-11446-10286@http.bugzilla.kernel.org/>
References: <bug-11446-10286@http.bugzilla.kernel.org/>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 09:24:42 -0700 (PDT)
bugme-daemon@bugzilla.kernel.org wrote:

> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11446
> 
>            Summary: Automate "to compile as module" strings
>            Product: Other
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: enhancement
>           Priority: P1
>          Component: Configuration
>         AssignedTo: zippel@linux-m68k.org
>         ReportedBy: kernel1@cyberdogtech.com
> 
> 
> I've spent quite a bit of time scanning through Kconfig files correcting
> various textual errors.  One thing that I've noticed is variations of "To
> compile X as a module, choose M here.  The module will be called Y" occur
> extremely frequently.  A quick grep of the current mainline actually reveals
> ~1192 instances of it.  It seems very redundant to me to have everyone who adds
> a module or feature copy and paste this text, when it could seemingly be
> dynamically generated with ease.
> 
> Is there any reason we can't simply standardize on one string, and display it
> for any component that has the module option available?

Good point :)

The Kconfig system doesn't presently know the name of the module,
but that could be added.  eg:


  config BMAC
	tristate "BMAC (G3 ethernet) support"
	depends on PPC_PMAC && PPC32
+	modulename bmac
	select CRC32
	help
	  Say Y for support of BMAC Ethernet interfaces. These are used on G3
	  computers.

-	  To compile this driver as a module, choose M here: the module
-	  will be called bmac.


Any sane organisation would look at the benefit of this, weigh that
against the massive amount of code churn and would then run away howling.


