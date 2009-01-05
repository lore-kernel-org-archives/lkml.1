Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbZAEPk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbZAEPk1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 10:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbZAEPkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 10:40:17 -0500
Received: from nlpi053.sbcis.sbc.com ([207.115.36.82]:43870 "EHLO
	nlpi053.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbZAEPkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 10:40:16 -0500
Date: Mon, 5 Jan 2009 09:37:36 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@quilx.com
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] mm: __nr_to_section - make it safe against overflow
In-Reply-To: <20090105152848.GG7645@localhost>
Message-ID: <Pine.LNX.4.64.0901050935120.13628@quilx.com>
References: <20090105094034.GA7645@localhost> <Pine.LNX.4.64.0901050906180.12774@quilx.com>
 <20090105152848.GG7645@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: -2.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009, Cyrill Gorcunov wrote:

> yes, I know, that is why I've changed WARN_ON_ONCE to plain WARN_ON.

This is still going to create a gazillion of checks in the code because it
will be expanded numerous times.

> | I would think that the code does not have the tests because of performance
> | and code size concerns. Can we just say that a sane nr must be passed to
> | __nr_section?
> |
>
> If you mean did I test this patch for speed regresson then to be fair --
> no, I didn't. BUT we have a number of macros wich are self protective
> like present_section which is used havily too. On the other hand --
> bad argument passed to __nr_to_section will be (and it is now) really
> harmfull -- since it would allow to reference a memory outside the
> valid bounds. The second -- SECTION_ROOT_MASK wich is fragile, any
> attempt to modify mem_section structure will silently lead to insane
> referencing, that is why it deserve a comment on top of structure.
>
> Don't know Christoph, if it really that important to not spend a few
> cycles here in a sake of safety -- we could easily drop this patch.

The problem is that these few cycles aggregate. Both because these inline
primitives are frequently used and because developers add more of these
checks over time.
