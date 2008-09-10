Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYIJMI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYIJMI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752080AbYIJMIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:08:47 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:43668 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbYIJMIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:08:47 -0400
Date: Wed, 10 Sep 2008 08:08:46 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] make setpriority POSIX compliant; introduce
	PRIO_THREAD extension
Message-ID: <20080910120846.GA4857@infradead.org>
References: <1220278355.3866.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220278355.3866.21.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2008 at 04:12:35PM +0200, Denys Vlasenko wrote:
> Attached patch changes setpriority(PRIO_PROCESS) to set priority
> for all threads with selected pid. getpriority is changed accordingly,
> to return the (numerical) max of all threads' priority.
> 
> In order to allow priority of individual threads to be manipulated,
> patch adds PRIO_THREAD which acts on single thread, always.

Bad idea, you silently change the existing interface, and programs that
used to work around the old Linux behvaiour silently break.  Just keep
PRIO_PROCESS as it was and add a new PRIO_TGROUP that does the Posix
functionality for the whole thread group.  Glibc can then implement
the library-PRIO_PROCESS as PRIO_TGROUP for newly linked applications
without breaking existing ones.

