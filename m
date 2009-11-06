Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbZKFWKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbZKFWKP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbZKFWKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:10:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24570 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759945AbZKFWKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:10:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: copy_thread() should clear TIF_SINGLESTEP and
	X86_EFLAGS_TF
In-Reply-To: Oleg Nesterov's message of  Friday, 6 November 2009 22:50:04 +0100 <20091106215004.GA2232@redhat.com>
References: <20091106211637.GA1696@redhat.com>
	<20091106212554.BD731CF@magilla.sf.frob.com>
	<20091106215004.GA2232@redhat.com>
X-Windows: never had it, never will.
Message-Id: <20091106221002.8057DCF@magilla.sf.frob.com>
Date: Fri,  6 Nov 2009 14:10:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I thought this flag has no effect without TIF_SINGLESTEP, and it is
> always updated by enable_single_step().

Right, but to be anal about the semantics you shouldn't clear TF if it's
not set, etc.

> user_disable_single_step() is very much arch-dependent, I am worried
> if it is safe to call it from copy_process(), when the new task_struct,
> thread_info, etc are not properly initialized yet...

Well, arch people can weigh in about if it is problematical.
Skimming over the existing arch definitions, it looks OK to me.


Thanks,
Roland
