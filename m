Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYLJSm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYLJSm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 13:42:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754802AbYLJSmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 13:42:45 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:57896 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbYLJSmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 13:42:44 -0500
Date: Wed, 10 Dec 2008 19:44:10 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/15] kmemleak: Keep the __init functions after initialization
Message-ID: <20081210184410.GA15070@uranus.ravnborg.org>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com> <20081210182806.30323.62122.stgit@pc1117.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081210182806.30323.62122.stgit@pc1117.cambridge.arm.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2008 at 06:28:06PM +0000, Catalin Marinas wrote:
> This patch adds the CONFIG_DEBUG_KEEP_INIT option which preserves the
> .init.* sections after initialization. Memory leaks happening during
> this phase can be more easily tracked.

This patch manipulate the section names of these functions.
The better way would be to keep the section names as they are
and then in init.h decide where to add these sections.

This will require a new set of CONFIG_ symbols but then
it is obvious what happens.

Something like:

config	KEEP_INIT
	bool

config	KMEMLEAK
	...
	select KEEP_INIT
	select DEBUG_KEEP_CPUINIT
	select DEBUG_KEEP_MEMINIT

config HOTPLUG
	...
	select KEEP_INIT

And then use these symbols in vmlinux.lds.h

	Sam
