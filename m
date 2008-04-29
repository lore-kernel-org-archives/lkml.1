Return-Path: <linux-kernel-owner+w=401wt.eu-S1755199AbYD2Dyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755199AbYD2Dyf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 23:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752810AbYD2Dy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 23:54:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:44340 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752567AbYD2Dy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 23:54:27 -0400
Subject: PTRACE_{READ,WRITE}{TEXT,DATA}
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Roland McGrath <roland@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
Content-Type: text/plain
Date: Tue, 29 Apr 2008 13:54:08 +1000
Message-Id: <1209441248.18023.124.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Roland, David !

I noticed kernel/ptrace.c has ptrace_readdata/writedata functions that
are only used by sparc and sparc64 which implements the ptrace requests
PTRACE_READ_DATA, PTRACE_WRITE_DATA (and _TEXT variants).

Any reason not to make everybody benefit from these and moving the sparc
implementation to the generic ptrace_request (&compat) ?

It's more efficient than read/writing one word at a time... I thought
about it in the light of some work Rik is doing to make
access_process_vm useable on video ram mappings done by the X server...

If you are ok, I'll do a patch.

Cheers,
Ben

