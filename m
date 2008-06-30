Return-Path: <linux-kernel-owner+w=401wt.eu-S1764055AbYF3VD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764055AbYF3VD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753891AbYF3VDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:03:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60818 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbYF3VDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:03:10 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: TAKADA Yoshihito <takada@mbf.nifty.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ptrace GET/SET FPXREGS broken
In-Reply-To: TAKADA Yoshihito's message of  Monday, 30 June 2008 13:44:45 +0900 <20080630.134445.193700135.takada@mbf.nifty.com>
References: <20080630.134445.193700135.takada@mbf.nifty.com>
X-Zippy-Says: ..I'll make you an ASHTRAY!!
Message-Id: <20080630210245.8BA76154077@magilla.localdomain>
Date: Mon, 30 Jun 2008 14:02:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the report.  That was indeed a regression from 2.6.24 in ptrace.
To match traditional behavior, ptrace should only ever return -EIO for all
kinds of errors accessing registers (except for the -ESRCH cases).  But it
is cleaner for the user_regset calls to use meaningful error codes, and
-ENODEV is what makes sense for the !cpu_has_fxsr case.
So the right fix for this is in ptrace, not in user_regset.

Ingo, please revert takada's patch and apply the one about to come from me.


Thanks,
Roland
