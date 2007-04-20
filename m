Return-Path: <linux-kernel-owner+w=401wt.eu-S1030827AbXDTTP5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030827AbXDTTP5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 15:15:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754492AbXDTTP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 15:15:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49877 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754489AbXDTTP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 15:15:57 -0400
Date: Fri, 20 Apr 2007 12:15:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Balbir Singh <balbir@in.ibm.com>
Cc: nagar@watson.ibm.com, jlan@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Taskstats fix the structure members alignment issue
Message-Id: <20070420121543.6a1a8426.akpm@linux-foundation.org>
In-Reply-To: <20070420164341.14718.5013.sendpatchset@balbir-laptop>
References: <20070420164341.14718.5013.sendpatchset@balbir-laptop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 22:13:41 +0530
Balbir Singh <balbir@in.ibm.com> wrote:

> 
> We broke the the alignment of members of taskstats to the 8 byte boundary
> with the CSA patches. In the current kernel, the taskstats structure is
> not suitable for use by 32 bit applications in a 64 bit kernel.
> 

ugh, that was bad of us.

> ...
> The patch adds an __attribute__((aligned(8))) to the
> taskstats structure members so that 32 bit applications using taskstats
> can work with a 64 bit kernel.

But there might be 32-bit applications out there which are using the
present wrong structure?

otoh, I assume that those applications would be using taskstats.h and would
hence encounter this bug and we would have heard about it, is that correct?

otoh^2, 32-bit applications running under 32-bit kernels will presently be
functioning correctly, and your change will require that those applications
be recompiled, I think?


This patch looks like 2.6.20 and 2.6.21 material, but very carefully...
