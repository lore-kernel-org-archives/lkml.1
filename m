Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYD2Eo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYD2Eo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751697AbYD2EoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:44:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYD2EoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:44:17 -0400
Date: Tue, 29 Apr 2008 00:44:05 -0400
From: Rik van Riel <riel@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: benh@kernel.crashing.org, roland@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
Message-ID: <20080429004405.2c375723@bree.surriel.com>
In-Reply-To: <20080428.213416.193699665.davem@davemloft.net>
References: <1209441248.18023.124.camel@pasglop>
	<20080428.213416.193699665.davem@davemloft.net>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Apr 2008 21:34:16 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

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
> See linux_proc_xfer_partial() in gdb/linux-nat.c

Strange, changing access_process_vm on Fedora 9 made gdb able to
see video memory that the X server had mmapped.

Are you sure gdb behaves as you suggest?  

On x86 my patch seems to work as I expected...

-- 
All rights reversed.
