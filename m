Return-Path: <linux-kernel-owner+w=401wt.eu-S1760159AbZCWQ5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760159AbZCWQ5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 12:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbZCWQ52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 12:57:28 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:51254 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758205AbZCWQ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 12:57:27 -0400
Date: Mon, 23 Mar 2009 17:57:20 +0100
From: Daniel Mack <daniel@caiaq.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel/trace/trace_functions_graph.c: fix nsecs_str
	buffer size
Message-ID: <20090323165720.GC5393@buzzloop.caiaq.de>
References: <1237824637-28190-1-git-send-email-daniel@caiaq.de> <20090323164030.GA5988@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090323164030.GA5988@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Frederic,

On Mon, Mar 23, 2009 at 05:40:31PM +0100, Frederic Weisbecker wrote:
> It can't really happen because nsecs_rem is a rest of a division
> per 1000, so it will not exceed 3 digits (so it should be [4] and not
> [5], btw).
> 
> I must confess I should have added a better comment on this
> area.
> 
> We are printing a duration in usec with a part in nsec with the following
> constraints:
> 
> _ never exceed 7 characters unless we are are upper 9999999 usecs
> _ always keep the usecs consistants
> 
> Which means that while we have 4 or lesser digits for the usecs, we can
> print the 3 digits of the nanosecs.
> 
> If we need 5 for usecs, drop the least significant nanosec digit.
> If we need 6 for usecs, drop the two least significant nanosec digits

Ok, I see. I was just confused about the max len argument to snprintf()
(and so was cppcheck), but at a closer look, this can't become a
problem.

Nevermind, drop the patch - but good that we talked about it :)

Daniel

