Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbYHLPLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbYHLPLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 11:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752033AbYHLPLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 11:11:34 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:52941 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYHLPLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 11:11:33 -0400
Subject: Re: checkpoint/restart ABI
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Peter Chubb <peterc@gelato.unsw.edu.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Theodore Tso <tytso@mit.edu>,
       Arnd Bergmann <arnd@arndb.de>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <87d4kfds5i.wl%peterc@chubb.wattle.id.au>
References: <20080807224033.FFB3A2C1@kernel>
	 <200808090013.41999.arnd@arndb.de> <20080811152201.GB25930@us.ibm.com>
	 <200808111853.13854.arnd@arndb.de> <1218484114.5598.43.camel@nimitz>
	 <48A0CD86.6030704@goop.org>  <87d4kfds5i.wl%peterc@chubb.wattle.id.au>
Content-Type: text/plain
Date: Tue, 12 Aug 2008 08:11:10 -0700
Message-Id: <1218553870.5598.83.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-08-12 at 09:54 +1000, Peter Chubb wrote:
> Jeremy>    * multiple processes * pipes * UNIX domain sockets * INET
> Jeremy> sockets (both inter and intra machine) * unlinked open files *
> Jeremy> checkpointing file content * closed files (ie, files which
> Jeremy> aren't currently open, but will be soon, esp tmp files) *
> Jeremy> shared memory * (Peter, what have I forgotten?)
> 
> File sharing; multiple threads with wierd sharing arrangements (think:
> clone with various parameters, followed by exec in some of the threads
> but not others); MERT/system-V shared memory, semaphores and message
> queues; devices (audio, framebuffer, etc), HugeTLBFS, numa issues
> (pinning, memory layout), processes being debugged (so,
> checkpoint.restart a gdb/target pair), futexes, etc., etc.  Linux
> process state keeps expanding.

Yep, these are all challenges.  If you have some really specific
questions, or things you truly think can't be done, please speak up.
But, I really don't see any show stoppers in your list.

We also plan to do this incrementally.  The first consumers are likely
to be dumb, simple HPC apps that don't have real hardware like audio or
video.  Eventually, we'll get to real hardware like infiniband (ugh) or
audio.  Eventually.

(Actually futexes aren't that bad because they don't keep state
in-kernel)

-- Dave

