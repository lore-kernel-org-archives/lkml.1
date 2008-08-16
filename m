Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbYHPVuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbYHPVuo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 17:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751354AbYHPVuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 17:50:37 -0400
Received: from gw.goop.org ([64.81.55.164]:43918 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYHPVug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 17:50:36 -0400
Message-ID: <48A74BAA.4010908@goop.org>
Date: Sat, 16 Aug 2008 14:50:34 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH RFC 3/3] x86: use mwait for trigger API
References: <48A70192.7020002@goop.org> <20080816104404.070e0c14@infradead.org>
In-Reply-To: <20080816104404.070e0c14@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> monitor/mwait is rather really expensive.. are we really sure we want
> to use this?
> (from an Intel cpu perspective the answer is very likely no; but I don't
> know what AMD does here)
>   

The intended use is when you're going to be waiting for a while (on the
order of microseconds or more).  In the Xen case, I use this to block
the vcpu if we pass a few iterations without the condition being true. 
While the mwait patch doesn't do this at present, it could.

    J

