Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYD2Ee2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYD2Ee2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 00:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752466AbYD2EeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 00:34:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59348
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbYD2EeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 00:34:17 -0400
Date: Mon, 28 Apr 2008 21:34:16 -0700 (PDT)
Message-Id: <20080428.213416.193699665.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: roland@redhat.com, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: PTRACE_{READ,WRITE}{TEXT,DATA}
From: David Miller <davem@davemloft.net>
In-Reply-To: <1209441248.18023.124.camel@pasglop>
References: <1209441248.18023.124.camel@pasglop>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Tue, 29 Apr 2008 13:54:08 +1000

> I noticed kernel/ptrace.c has ptrace_readdata/writedata functions that
> are only used by sparc and sparc64 which implements the ptrace requests
> PTRACE_READ_DATA, PTRACE_WRITE_DATA (and _TEXT variants).
> 
> Any reason not to make everybody benefit from these and moving the sparc
> implementation to the generic ptrace_request (&compat) ?
> 
> It's more efficient than read/writing one word at a time... I thought
> about it in the light of some work Rik is doing to make
> access_process_vm useable on video ram mappings done by the X server...

It's kind of pointless because what gdb does these days on Linux is
use the procfs 'mem' file to directly read in parts of the inferior's
address space.

See linux_proc_xfer_partial() in gdb/linux-nat.c
