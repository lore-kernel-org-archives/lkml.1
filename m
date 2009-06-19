Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbZFSJOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbZFSJOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 05:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZFSJOd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 05:14:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41529 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750884AbZFSJOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 05:14:32 -0400
Date: Fri, 19 Jun 2009 10:13:23 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/17] arm: arch_ptrace clean-up
Message-ID: <20090619091323.GA18246@flint.arm.linux.org.uk>
References: <20090425000634.313E4FC3C8@magilla.sf.frob.com> <20090425000732.ACB87FC3C8@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090425000732.ACB87FC3C8@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 05:07:32PM -0700, Roland McGrath wrote:
> This cleans up arch_ptrace() on arm to use the generic ptrace_request()
> for everything it can.  This gets rid of the non-arch ptrace internals
> magic from the arch code.

It also changes the semantics a bit, and I don't buy the "it doesn't
matter" comments, especially in the PT_SINGLESTEP case.  Having
PT_SINGLESTEP set the flag but later fail is not nice behaviour at all,
it means that, despite the ptrace call failing, the next time that the
task encounters a signal, it will enter single stepping mode.

Therefore, I believe this patch is wrong.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
