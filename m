Return-Path: <linux-kernel-owner+w=401wt.eu-S1759368AbZEZXA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759368AbZEZXA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 19:00:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758182AbZEZXAl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 19:00:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40527 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757685AbZEZXAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 19:00:40 -0400
Date: Tue, 26 May 2009 16:00:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: paul@mad-scientist.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
Message-Id: <20090526160017.98fc62e4.akpm@linux-foundation.org>
In-Reply-To: <878wkjobbm.fsf@basil.nowhere.org>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
	<878wkjobbm.fsf@basil.nowhere.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 May 2009 22:31:41 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Block signals during core dump
> 
> When a signal happens during core dump the core dump to a pipe 
> can fail, because the write returns short, but the ELF core dumpers
> cannot handle that.
> 
> There's no reason to handle signals during core dumping, so just
> block them all.
> 
> Open issue: ELF puts blocked signals into the core dump and
> that will be always fully blocked now.  Need to save it somewhere?
> 
> Based on debugging by Paul Smith.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

dump_write() doesn't seem right, either.  If ->write() returns, say,
100 then the dump should keep on going.  At present it treats this
return as an error.

I wonder why the signal problem has just turned up now - did we change
the pipe code or something?

