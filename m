Return-Path: <linux-kernel-owner+w=401wt.eu-S966010AbXG3Qhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966010AbXG3Qhh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 12:37:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967109AbXG3QgB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 12:36:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43538 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967077AbXG3Qf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 12:35:56 -0400
Subject: Re: [PATCH] Fix msr register allocation
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20070730153734.GA6921@atjola.homenet>
References: <1185809155.4347.20.camel@t60>
	 <20070730153734.GA6921@atjola.homenet>
Content-Type: text/plain; charset=utf-8
Organization: Red Hat
Date: Mon, 30 Jul 2007 13:35:57 -0300
Message-Id: <1185813358.4347.24.camel@t60>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-07-30 at 17:37 +0200, Björn Steinbrink wrote:
> On 2007.07.30 12:25:54 -0300, Glauber de Oliveira Costa wrote:
> > Since the value in ret will go through a return statement,
>                      ^^^
> You mean "err" I guess?
Yeah, you're right.

> Note that the EAX output constraint is re-used in the input section for
> (u32)val, i.e. the lower half of the value to be written. And "wrmsr"
> needs that in EAX, so you cannot change the output constraint without
> touching the input constraint.
Right again. Will send a new patch that also changes the input constraint.

> Also, I do not see how the compiler could do any better than having the
> return value already in EAX, but that doesn't really mean anything ;-)

Yet, we should only force the compiler to a particular choice when we 
have to, IMHO. So, unless anyone gives another reason not to, I will
send another patch with your warnings fixed.



