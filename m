Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXEaRUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXEaRUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 13:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754935AbXEaRUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 13:20:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:44539 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbXEaRUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 13:20:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Beh4Nc7CkytA6W6hs4mz4Tu15IoWBiXr1rssHu1cO+qW8n66xYbusTlCnjK4jYTDSgJyqv3RuprZ0cKpg5foUeLb5XUOR2enUw5BTIxa+0KJfAnEMlxstZzBVlUEt02+gwRWeVhpxildEt96go41NAEXrWG2rg/yMjtdHvCSBa0=
Message-ID: <a36005b50705311020w45094035uae4b63091d60ab7d@mail.gmail.com>
Date: Thu, 31 May 2007 10:20:11 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [PATCH RT] fix faulting bomb in futex_unlock_pi64
Cc: "john stultz" <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Sripathi Kodi" <sripathik@in.ibm.com>
In-Reply-To: <1180579953.21781.34.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180572567.6126.44.camel@localhost.localdomain>
	 <1180579953.21781.34.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Steven Rostedt <rostedt@goodmis.org> wrote:
> But, the -rt kernel has pretty much the same code for the
> futex_unlock_pi64, and it has the same bug.

Why would you use futex_unlock_pi64?

In fact, the whole 64-bit futex patch should be reviewed and cut down
to the bare minimum. I know, I was asking for it loudly but it became
to Jakub and me after adding the private futexes that all these
orthogonal extensions don't make sense.  So far we need 64-bit futexes
only for some rwlocks and here only a few operations (wait, wake).  We
don't need 64-bit extended to PI, we don't need requeue.

Yes, if we had started out with 64-bit futexes on 64-bit platforms,
that would be fine.  But as it is today making 64-bit a new dimension
is not needed.
