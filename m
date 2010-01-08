Return-Path: <linux-kernel-owner+w=401wt.eu-S1753261Ab0AHMZw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab0AHMZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 07:25:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752323Ab0AHMZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 07:25:51 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:59637 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab0AHMZu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 07:25:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=IJvDK4ADl8UgWxIeZyXcCsXeuydF9LLVbHY1RDrPbYVSiKRDOUrfJAbiy5ZorEa8Jm
         UiD+AcpQmm3I9MDIBhGL3HPI9wsi7pG+BTbKXLicMvxWmeUAlQMdGxS9JNzREd/p/H9u
         5x6qYIygpupRNoNLBd1dcjtFOD5hCAMzAmt34=
MIME-Version: 1.0
In-Reply-To: <20100108071200.GB15621@boogie.lpds.sztaki.hu>
References: <4B465C2D.8030303@gmail.com> <EB8593BCECAB3D40A8248BE0B6400A38315E5831@shzsmsx502.ccr.corp.intel.com> 
	<20100108071200.GB15621@boogie.lpds.sztaki.hu>
From: roel kluin <roel.kluin@gmail.com>
Date: Fri, 8 Jan 2010 13:25:29 +0100
Message-ID: <25e057c01001080425q33ea8641ncf940c60700e9410@mail.gmail.com>
Subject: Re: [PATCH] KVM: dereference of NULL pointer in set_pal_result()
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: "Zhang, Xiantao" <xiantao.zhang@intel.com>,
       "kvm-ia64@vger.kernel.org" <kvm-ia64@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> For the check "(p && p->exit_reason == EXIT_REASON_PAL_CALL", if p is NULL, the reference about "p->exit_reason == EXIT_REASON_PAL_CALL" won't be checked any more, so no issue here.

>> >     p = kvm_get_exit_data(vcpu);
>> > -   if (p && p->exit_reason == EXIT_REASON_PAL_CALL) {
>> > +   if (!p)
>> > +           return;
>> > +   if (p->exit_reason == EXIT_REASON_PAL_CALL) {
>> >             p->u.pal_data.ret = result;
>> > -           return ;
>> > +           return;
>> >     }
>> >     INIT_PAL_STATUS_UNIMPLEMENTED(p->u.pal_data.ret);
>
> IMHO it's not the test but the INIT_PAL_STATUS_UNIMPLEMENTED() that does
> the unwanted dereferencing, and that's fixed by the patch.
>
> Gabor

Correct. Thanks,

Roel
