Return-Path: <linux-kernel-owner+w=401wt.eu-S1755539AbZKUQfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbZKUQfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Nov 2009 11:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbZKUQfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Nov 2009 11:35:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45006 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019AbZKUQfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Nov 2009 11:35:06 -0500
Date: Sat, 21 Nov 2009 14:35:04 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] perf symbols: fixup kernel_maps__fixup_end end map
Message-ID: <20091121163504.GI18283@ghostprotocols.net>
References: <1258821086-11521-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258821086-11521-1-git-send-email-acme@infradead.org>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Nov 21, 2009 at 02:31:24PM -0200, Arnaldo Carvalho de Melo escreveu:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> We better call this routine after both the kernel and modules are
> loaded, because as it was if there weren't modules it would be called,

s/would/would not/g

Ingo, if you see this before merging, please ammend the above comment
line :)

> resulting in kernel_map->end remaining at zero, so no map would be found
> and consequently the kernel symtab wouldn't get loaded, i.e. no kernel
> symbols would be resolved.
> 
> Also this fixes another case, that is when we _have_ modules, but the
> last map would have its ->end address not set before we loaded its
> symbols, which would never happen because ->end was not set.
