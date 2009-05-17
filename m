Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZEQVGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZEQVGk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 17:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbZEQVG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 17:06:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:45984 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbZEQVG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 17:06:29 -0400
Date: Sun, 17 May 2009 14:03:58 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, tom.leiming@gmail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] kernel:async function call:introduce
 async_run_inatomic(v2)
Message-ID: <20090517140358.751e12b7@infradead.org>
In-Reply-To: <20090514031937.GA5476@nowhere>
References: <1242229899-16761-1-git-send-email-tom.leiming@gmail.com>
	<20090513191144.6aae00d7@gondolin>
	<20090514031937.GA5476@nowhere>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 May 2009 05:19:39 +0200
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> But I wonder if async_run_inatomic() is really matching any common
> pattern inside the kernel.
> It seems to me rare to never need waiting for an async job completion.

there are some very good reasons to have the option to wait for all;
module unloading comes to mind for example.

I'd not like it to automatically punt all async "inatomic" work to a
separate space; that should be an option for the caller.
If the work is not going to take long, it's actually GOOD that you can
globally synchronize for it...

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
