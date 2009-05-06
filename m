Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZEFCEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZEFCEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 22:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbZEFCEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 22:04:00 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbZEFCD7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 22:03:59 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ptrace: ptrace_attach: check PF_KTHREAD + exit_state
	instead of ->mm
In-Reply-To: Oleg Nesterov's message of  Wednesday, 6 May 2009 00:47:22 +0200 <20090505224722.GA954@redhat.com>
References: <20090505224722.GA954@redhat.com>
X-Shopping-List: (1) Impotent spearmint load bacon
   (2) Ancient snowbulb carnations
   (3) Indecent rodent samples
   (4) Felonious bum dwarves
Message-Id: <20090506020223.A4F1AFC328@magilla.sf.frob.com>
Date: Tue,  5 May 2009 19:02:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the order of the already-traced and security checks.
It would match the previous behavior to have the ->exit_state and ->ptrace
checks before __ptrace_may_access().  This is a small nit, but it could
affect whether some existing harmless usage pattern starts generating new
access failure logging from security modules (e.g. SELinux avc denials).

I don't see any reason you can't just swap the order back as it was before.
If you do that,
Acked-by: Roland McGrath <roland@redhat.com>


Thanks,
Roland
