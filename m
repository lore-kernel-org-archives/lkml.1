Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYAQTky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYAQTky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 14:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753583AbYAQTkq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 14:40:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57276 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751681AbYAQTkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 14:40:45 -0500
Date: Thu, 17 Jan 2008 11:40:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: <balbir@linux.vnet.ibm.com>, <linux-kernel@vger.kernel.org>,
       "Linux ACPI mailing list" <linux-acpi@vger.kernel.org>,
       "Intel E/100 mailing list" <e1000-devel@lists.sourceforge.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: 2.6.24-rc8-mm1
Message-Id: <20080117114032.1f9f1df5.akpm@linux-foundation.org>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com>
References: <20080117023514.9df393cf.akpm@linux-foundation.org>
	<20080117124622.GA18450@balbir.in.ibm.com>
	<20080117104021.25a8e562.akpm@linux-foundation.org>
	<924EFEDD5F540B4284297C4DC59F3DEE5E909A@orsmsx423.amr.corp.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jan 2008 11:22:19 -0800 "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

>  
> The problem is
> >> modprobe:2584 conflicting cache attribute 50000000-50001000
> >> uncached<->default
> 
> Some address range here is being mapped with conflicting types.
> Somewhere the range was mapped with default (write-back). Later
> pci_iomap() is mapping that region as uncacheable which is basically
> aliasing. PAT code detects the aliasing and fails the second uncacheable
> request which leads in the failure.

It sounds to me like you need considerably more runtime debugging and
reporting support in that code.  Ensure that it generates enough output
both during regular operation and during failures for you to be able to
diagnose things in a single iteration.

We can always take it out later.


