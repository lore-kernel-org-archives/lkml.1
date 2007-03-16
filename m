Return-Path: <linux-kernel-owner+w=401wt.eu-S965818AbXCPSQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818AbXCPSQT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2007 14:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965821AbXCPSQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Mar 2007 14:16:19 -0400
Received: from smtp.osdl.org ([65.172.181.24]:57933 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965818AbXCPSQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2007 14:16:18 -0400
Date: Fri, 16 Mar 2007 10:15:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paulo Marques <pmarques@grupopie.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alexey Dobriyan <adobriyan@sw.ru>,
       linux-kernel@vger.kernel.org, devel@openvz.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, rusty@rustcorp.com.au
Subject: Re: [PATCH RESEND 2/2] Fix some kallsyms_lookup() vs rmmod races
Message-Id: <20070316101514.8a8ffbc7.akpm@linux-foundation.org>
In-Reply-To: <45FAD0F7.5090506@grupopie.com>
References: <20070316114458.GB6817@localhost.sw.ru>
	<20070316115154.GC30195@elte.hu>
	<45FAC2CA.80009@grupopie.com>
	<20070316161853.GD9413@elte.hu>
	<45FAD0F7.5090506@grupopie.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2007 17:16:39 +0000 Paulo Marques <pmarques@grupopie.com> wrote:

> Does freeze_processes() / unfreeze_processes() solve this by only 
> freezing processes that have voluntarily scheduled (opposed to just 
> being preempted)?

It goes much much further than that.  Those processes need to actually
perform an explicit call to try_to_freeze().
