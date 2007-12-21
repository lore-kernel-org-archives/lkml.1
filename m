Return-Path: <linux-kernel-owner+w=401wt.eu-S1759285AbXLUXc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759285AbXLUXc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 18:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754308AbXLUXcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 18:32:22 -0500
Received: from ns.suse.de ([195.135.220.2]:53801 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627AbXLUXcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 18:32:21 -0500
To: "Jan Beulich" <jbeulich@novell.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] add task handling notifier: base definitions
From: Andi Kleen <andi@firstfloor.org>
References: <476A7832.76E4.0078.0@novell.com>
Date: Sat, 22 Dec 2007 00:32:20 +0100
In-Reply-To: <476A7832.76E4.0078.0@novell.com> (Jan Beulich's message of "Thu\, 20 Dec 2007 13\:12\:02 +0000")
Message-ID: <p7363yrfwu3.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Jan Beulich" <jbeulich@novell.com> writes:

> This is the base patch, adding notification for task creation and
> deletion.

I like the basic concept. At some point I suspect we'll even need
a per task dynamic data allocator, that would remove even
more cruft.

Could you change the block notifier calls first to not take their lock
when there is nothing in the list (the common case)? It is 
weird that they don't already do this, but they should definitely
here.

I think the use of the blocking/atomic notifiers needs some comment.
I think I understand why you did it -- exit atomic because sleeping
in exit can be illegal and blocking for fork to allow GFP_KERNEL
allocations -- but that should be documented somewhere.

-Andi
