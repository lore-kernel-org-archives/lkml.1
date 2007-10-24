Return-Path: <linux-kernel-owner+w=401wt.eu-S1760317AbXJXReX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760317AbXJXReX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 13:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754934AbXJXReP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 13:34:15 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59691 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754913AbXJXReO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 13:34:14 -0400
Date: Wed, 24 Oct 2007 10:34:11 -0700
From: Paul Jackson <pj@sgi.com>
To: "Paul Menage" <menage@google.com>
Cc: bunk@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cgroup.c: remove dead code
Message-Id: <20071024103411.dfd3ae04.pj@sgi.com>
In-Reply-To: <6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
References: <20071024162534.GZ30533@stusta.de>
	<6599ad830710240930r6649dec0q21b8c00f7d8a796a@mail.gmail.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul M wrote:
> I think I'd rather not make this change - if we later changed the size
> of release_agent_path[] this could silently fail. Can we get around
> the coverity checker somehow?

Perhaps we can simplify this check then, to:

  BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX));

Less runtime code.

This patch of Adrian highlighted a couple more opportunities
for code tweaking ... see my RFC patches, coming next from me.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
