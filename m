Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752389AbYLQNJZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbYLQNJZ (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 08:09:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLQNJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 08:09:15 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:41909 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbYLQNJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 08:09:14 -0500
Subject: Re: [PATCH 13/15] kmemleak: Keep the __init functions after
	initialization
From: Catalin Marinas <catalin.marinas@arm.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081210184410.GA15070@uranus.ravnborg.org>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182806.30323.62122.stgit@pc1117.cambridge.arm.com>
	 <20081210184410.GA15070@uranus.ravnborg.org>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 17 Dec 2008 13:09:05 +0000
Message-Id: <1229519345.32517.16.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Dec 2008 13:09:07.0194 (UTC) FILETIME=[A49575A0:01C96048]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam,

On Wed, 2008-12-10 at 19:44 +0100, Sam Ravnborg wrote:
> On Wed, Dec 10, 2008 at 06:28:06PM +0000, Catalin Marinas wrote:
> > This patch adds the CONFIG_DEBUG_KEEP_INIT option which preserves the
> > .init.* sections after initialization. Memory leaks happening during
> > this phase can be more easily tracked.
> 
> This patch manipulate the section names of these functions.
> The better way would be to keep the section names as they are
> and then in init.h decide where to add these sections.
> 
> This will require a new set of CONFIG_ symbols but then
> it is obvious what happens.

Thanks for your comments. I had a look at the vmlinux.lds.h file and
there are indeed better options like DEV_KEEP etc.

Anyway, I think I'll drop this patch completely. All that kmemleak needs
is actually the kernel symbols to be able to print the stack trace.
These don't seem to be removed together with the .init sections cleanup.

-- 
Catalin

