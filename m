Return-Path: <linux-kernel-owner+w=401wt.eu-S1756122AbZKIQ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbZKIQ32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755969AbZKIQ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:29:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371AbZKIQ31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:29:27 -0500
Date: Mon, 9 Nov 2009 17:24:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] ptrace: copy_process() should disable stepping
Message-ID: <20091109162408.GA5160@redhat.com>
References: <20091106211637.GA1696@redhat.com> <20091106212554.BD731CF@magilla.sf.frob.com> <20091106215004.GA2232@redhat.com> <20091106221002.8057DCF@magilla.sf.frob.com> <20091107215547.GA25335@redhat.com> <20091109041546.925461E@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109041546.925461E@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08, Roland McGrath wrote:
>
> That is inappropriate use of arch details in generic code.  It might
> happen to be harmless fritter in practice on the arch's we have but it
> is certainly not the correct way to go about things.  You should just
> call user_disable_single_step() unconditionally.  Even on an arch with
> no such machinery at all that should be defined safely as a no-op (see
> linux/ptrace.h).  If there is some reason not to do that, please
> explain it.

Yes, we have arch_has_single_step.

I added test_tsk_thread_flag(TIF_SINGLESTEP) check for 2 reasons: to
optimize out user_disable_single_step() in the likely case, and because
I wasn't sure it is safe to call user_disable_single_step() unconditionally.

OK, will resend, thanks.

Oleg.

