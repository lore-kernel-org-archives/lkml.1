Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbXDUTdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbXDUTdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 15:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXDUTdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 15:33:46 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:52905 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbXDUTdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 15:33:45 -0400
Date: Sat, 21 Apr 2007 12:33:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: balbir@linux.vnet.ibm.com
Cc: Balbir Singh <balbir@in.ibm.com>, nagar@watson.ibm.com, jlan@sgi.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Taskstats fix the structure members alignment issue
Message-Id: <20070421123307.5dc2566f.akpm@linux-foundation.org>
In-Reply-To: <462A0AA9.8000304@linux.vnet.ibm.com>
References: <20070420164341.14718.5013.sendpatchset@balbir-laptop>
	<20070420121543.6a1a8426.akpm@linux-foundation.org>
	<462A0AA9.8000304@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Apr 2007 18:29:21 +0530 Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> >> The patch adds an __attribute__((aligned(8))) to the
> >> taskstats structure members so that 32 bit applications using taskstats
> >> can work with a 64 bit kernel.
> > 
> > But there might be 32-bit applications out there which are using the
> > present wrong structure?
> > 
> > otoh, I assume that those applications would be using taskstats.h and would
> > hence encounter this bug and we would have heard about it, is that correct?
> > 
> 
> Yes, correct.
> 
> > otoh^2, 32-bit applications running under 32-bit kernels will presently be
> > functioning correctly, and your change will require that those applications
> > be recompiled, I think?
> > 
> 
> Yes, correct. They would be broken with this fix. We could  bump up the
> version TASKSTATS_VERSION to 4. Would you like a new patch the version
> bumped up?

I can do that.

> > 
> > This patch looks like 2.6.20 and 2.6.21 material, but very carefully...
> 
> Yes, 2.6.20 and 2.6.21 sound correct.

OK.  I guess we have little choice but to slam it in asap, with a 2.6.20.x backport
before too many people start using the old interface.
