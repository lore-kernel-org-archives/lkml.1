Return-Path: <linux-kernel-owner+w=401wt.eu-S1762713AbYF0UDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762713AbYF0UDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 16:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758135AbYF0UDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 16:03:11 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:43131 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbYF0UDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 16:03:10 -0400
Date: Fri, 27 Jun 2008 16:00:50 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Joris van Rantwijk <jorispubl@xs4all.nl>
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Thorsten Knabe <linux@thorsten-knabe.de>,
       Roland McGrath <roland@redhat.com>
Subject: Re: BUG: Linux 2.6.25 ptrace leaks struct_task
Message-ID: <20080627200050.GA10859@c2.user-mode-linux.org>
References: <20080627183045.GA18801@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627183045.GA18801@xs4all.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 08:30:45PM +0200, Joris van Rantwijk wrote:
> I think sys32_ptrace() is leaking struct_task.
> 
> In arch/x86/kernel/ptrace.c, function sys32_ptrace(), there
> is a call to ptrace_get_task_struct(). In some cases (such as
> PTRACE_GETREGS), there is no matching call to put_task_struct().

Yup, good diagnosis.  The culprit is
5a4646a4efed8c835f76c3b88f3155f6ab5b8d9b.  Doing an s/return /ret = /
inside that switch should fix the bug.

It looks like it's since been fixed in mainline by the restructuring
done in 562b80bafffaf42a6d916b0a2ee3d684220a1c10.

			Jeff

-- 
Work email - jdike at linux dot intel dot com
