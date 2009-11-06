Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZKFVy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZKFVy5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 16:54:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758659AbZKFVy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 16:54:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753739AbZKFVyz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 16:54:55 -0500
Date: Fri, 6 Nov 2009 22:50:04 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: copy_thread() should clear TIF_SINGLESTEP and
	X86_EFLAGS_TF
Message-ID: <20091106215004.GA2232@redhat.com>
References: <20091106211637.GA1696@redhat.com> <20091106212554.BD731CF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091106212554.BD731CF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06, Roland McGrath wrote:
>
> There is also the TIF_FORCED_TF logic to check.

I thought this flag has no effect without TIF_SINGLESTEP, and it is
always updated by enable_single_step().

> Probably it should just
> call user_disable_single_step() instead.  Perhaps copy_process() should
> just call that and then no per-arch changes would be required.

OK, thanks, will resend tomorrow.

user_disable_single_step() is very much arch-dependent, I am worried
if it is safe to call it from copy_process(), when the new task_struct,
thread_info, etc are not properly initialized yet...

Oleg.

