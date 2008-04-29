Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYD2FGv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYD2FGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 01:06:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYD2FGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 01:06:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:34789 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756002AbYD2FGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 01:06:38 -0400
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org, riel@redhat.com
In-Reply-To: <20080428.213416.193699665.davem@davemloft.net>
References: <1209441248.18023.124.camel@pasglop>
	 <20080428.213416.193699665.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 15:06:20 +1000
Message-Id: <1209445580.18023.131.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-28 at 21:34 -0700, David Miller wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Date: Tue, 29 Apr 2008 13:54:08 +1000
> 
> > I noticed kernel/ptrace.c has ptrace_readdata/writedata functions that
> > are only used by sparc and sparc64 which implements the ptrace requests
> > PTRACE_READ_DATA, PTRACE_WRITE_DATA (and _TEXT variants).
> > 
> > Any reason not to make everybody benefit from these and moving the sparc
> > implementation to the generic ptrace_request (&compat) ?
> > 
> > It's more efficient than read/writing one word at a time... I thought
> > about it in the light of some work Rik is doing to make
> > access_process_vm useable on video ram mappings done by the X server...
> 
> It's kind of pointless because what gdb does these days on Linux is
> use the procfs 'mem' file to directly read in parts of the inferior's
> address space.
> 
> See linux_proc_xfer_partial() in gdb/linux-nat.c=

Good point. That still uses access_process_vm() so Rik and I work
is still valid tho.

Thanks,
Ben.


