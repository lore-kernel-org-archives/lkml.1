Return-Path: <linux-kernel-owner+w=401wt.eu-S1030621AbXDJWfH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030621AbXDJWfH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 18:35:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030649AbXDJWfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 18:35:06 -0400
Received: from smtprelay02.ispgateway.de ([80.67.18.14]:54732 "EHLO
	smtprelay02.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030621AbXDJWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 18:35:04 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: init's children list is long and slows reaping children.
Date: Wed, 11 Apr 2007 00:35:35 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>,
       Robin Holt <holt@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jack Steiner <steiner@americas.sgi.com>
References: <20070405195118.GH22762@lnx-holt.americas.sgi.com> <20070410014102.fd730911.akpm@linux-foundation.org> <461B4F76.1010807@garzik.org>
In-Reply-To: <461B4F76.1010807@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704110035.37563.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2007, Jeff Garzik wrote:
> Thus, rather than forcing authors to make their code more complex, we 
> should find another solution.

What about sth. like the "pre-forking" concept? So just have a thread creator thread,
which checks the amount of unused threads and keeps them within certain limits.

So that anything which needs a thread now simply queues up the work and
specifies, that it wants a new thread, if possible.

One problem seems to be, that a thread is nothing else but a statement
on what other tasks I can wait before doing my current one (e.g. I don't want to 
mlseep() twice on the same reset timeout). 
But we usually use locking to order that.

Do I miss anything fundamental here?

Regards

Ingo Oeser
