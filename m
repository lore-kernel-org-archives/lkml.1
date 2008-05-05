Return-Path: <linux-kernel-owner+w=401wt.eu-S1752380AbYEETF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380AbYEETF3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763619AbYEETEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:04:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932656AbYEETEU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:04:20 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Anoop <acv@linux.vnet.ibm.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: ptrace PTRACE_PEEKUSER behavior
In-Reply-To: Anoop's message of  Monday, 5 May 2008 07:01:28 -0400 <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com>
References: <20080505070128.7i8vmxjq8g8go4ws@imap.linux.ibm.com>
Emacs: the prosecution rests its case.
Message-Id: <20080505190418.1323126FA20@magilla.localdomain>
Date: Mon,  5 May 2008 12:04:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct user' is really a virtual structure layout, and never exists
anywhere as an actual struct.  It's really just defining the argument
values that can be used in PEEKUSR/POKEUSR calls.  Its details are
completely machine-specific.  On x86, only the user_regs_struct parts at
the beginning, and the u_debugreg parts near the end, are offsets that are
valid in ptrace calls.  The other elements in x86's 'struct user' are just
historical cruft now.  Any documentation of the details would have to be
given for all the different arch layouts.


Thanks,
Roland
