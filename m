Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752697AbYLQXTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbYLQXTx (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751496AbYLQXTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:19:43 -0500
Received: from matrixpower.ru ([195.178.208.66]:44379 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751493AbYLQXTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:19:42 -0500
Date: Thu, 18 Dec 2008 02:19:41 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [w1] Allow master IO commands.
Message-ID: <20081217231941.GA29798@ioremap.net>
References: <1229450882-745-1-git-send-email-zbr@ioremap.net> <1229450882-745-2-git-send-email-zbr@ioremap.net> <20081217142241.e05fff98.akpm@linux-foundation.org> <20081217223352.GA28283@ioremap.net> <20081217151418.f17cee7c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081217151418.f17cee7c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 17, 2008 at 03:14:18PM -0800, Andrew Morton (akpm@linux-foundation.org) wrote:
> Do we have checks in there to ensure that we can't run off the end of
> the buffer?

Yes, w1_process_search_command() calls w1_search_devices() with the
w1_send_slave() callback which is invoked each time new slave is
detected. w1_send_slave() checks if amount of available data is enough
to store additional ID and sends message otherwise. The last message is
being sent with the flag indicating that, and it is sent no matter if
there were some slave devices found or not. 

> > Ok, I will space it to the left. Should I sent patch on top of it or
> > instead of?
> 
> Is OK, I'll fix it.  That change messes up the following patches so I
> fixed them as well.

Thanks a lot Andrew!

-- 
	Evgeniy Polyakov
