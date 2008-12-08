Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYLHWuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYLHWuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752855AbYLHWuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:50:00 -0500
Received: from netgear.net.ru ([195.178.208.66]:57480 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYLHWuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:50:00 -0500
Date: Tue, 9 Dec 2008 01:49:58 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, frederik.deweerdt@xprog.eu,
       randy.dunlap@oracle.com
Subject: Re: [W1] List slaves commands.
Message-ID: <20081208224958.GA29032@ioremap.net>
References: <1228480888739-git-send-email-zbr@ioremap.net> <1228480889246-git-send-email-zbr@ioremap.net> <12284808902058-git-send-email-zbr@ioremap.net> <12284808903744-git-send-email-zbr@ioremap.net> <20081208135848.2a529f86.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081208135848.2a529f86.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2008 at 01:58:48PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> This code performs quite a lot of potentially unaligned acceses.
> 
> Is there anything which guarantees that all these accesses are
> well-aligned?
> 
> If not, will there be issues with platforms which don't handle
> unaligned accesses as well as x86?
> 
> Should this code be using the unaligned access interfaces
> (get_unaligned, put_unaligned, etc.  Might be wrong.  Keeps changing. 
> Harvey Harrison is the guy to ask)?

Every store should be at least 4-bytes aligned because of used headers.
Particular mentioned command is 8-bytes aligned (and all its writes)
as long as others in this patchset (pointer alignment + 40 or 32 bytes
of the headers).

-- 
	Evgeniy Polyakov
