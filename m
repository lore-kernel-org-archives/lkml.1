Return-Path: <linux-kernel-owner+w=401wt.eu-S1765494AbXJSRQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765494AbXJSRQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 13:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754950AbXJSRQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 13:16:49 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55836 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbXJSRQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 13:16:49 -0400
Message-ID: <4718E67F.6000300@garzik.org>
Date: Fri, 19 Oct 2007 13:16:47 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/9] irq-remove: arch non-trivial
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075543.GC6407@havoc.gtf.org> <m1tzonghco.fsf@ebiederm.dsl.xmission.com>
In-Reply-To: <m1tzonghco.fsf@ebiederm.dsl.xmission.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> In this case we can easily pass the irqno into request_irq, allowing
> us to do "unsigned int intno = (unsigned int)dev_id;".
> 
> I suspect this is the case for the majority of the non-trivial users
> as well.


Not that easy, alas :)  Save for weirdos like the mac drivers I 
highlighted, it seems like most drivers in the non-trivial already pass 
a useful pointer to request_irq().

But as I mentioned, most of the "non-trivial" uses are actually trivial 
-- just not as simple as removing the 'int irq' argument.  Most of the 
time the irq number is used in non-critical ways like printk's.  A few 
times its used to index into a structure (something dev_id could replace).

	Jeff


