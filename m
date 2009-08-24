Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbZHXKye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbZHXKye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 06:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751052AbZHXKyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 06:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933AbZHXKyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 06:54:32 -0400
Date: Mon, 24 Aug 2009 12:50:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix race copy_process() vs de_thread()
Message-ID: <20090824105054.GA6966@redhat.com>
References: <4A9210A4.4010108@ct.jp.nec.com> <20090824061420.341A9414DF@magilla.sf.frob.com> <4A923403.6010201@ct.jp.nec.com> <20090824083826.GA475@redhat.com> <20090824085331.GB475@redhat.com> <20090824091558.BDAFE414DF@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824091558.BDAFE414DF@magilla.sf.frob.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24, Roland McGrath wrote:
>
> I think I like your first patch better.  It's a larger patch, but that's
> because it winds up with smaller code.

Yes, agreed.

And another reason for the first patch: ->live should not be used as a refcnt,
it is not. This should work for copy_process() but looks confusing and relies
on CLONE_THREAD subtleness anyway.

I'll re-check this patch and resend. I guess -stable needs this fix too.

Oleg.

