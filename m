Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbXKZTYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbXKZTYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 14:24:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXKZTYj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 14:24:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:50194 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbXKZTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 14:24:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH? 3/3] move daemonized kernel threads into the swapper's session
References: <20071126142556.GA16531@tv-sign.ru>
	<m14pf8omvz.fsf@ebiederm.dsl.xmission.com>
Date: Mon, 26 Nov 2007 12:23:26 -0700
In-Reply-To: <m14pf8omvz.fsf@ebiederm.dsl.xmission.com> (Eric W. Biederman's
	message of "Mon, 26 Nov 2007 11:57:36 -0700")
Message-ID: <m1ve7on74h.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:


> Hmm.  I wonder if we could ensure kernel_thread always
> returns a global pid_t, and then reallocate the struct
> pid for the task we have just daemonized so that it only
> has a single pid in the init_pid_ns.

Well we can't reallocate the struct pid, if anyone was using
it we would have problems, but we can certainly remove all
pid_t values except for those in the init_pid_ns.

We definitely have some serious issues with kernel_thread
and signal sending though.

Eric

