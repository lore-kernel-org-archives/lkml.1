Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZAFMGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZAFMGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 07:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbZAFMGD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 07:06:03 -0500
Received: from gate.crashing.org ([63.228.1.57]:56181 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519AbZAFMGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 07:06:01 -0500
Subject: Re: Lock-up on PPC64
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: michael@ellerman.id.au
Cc: malc <av1474@comtv.ru>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1231158516.8367.3.camel@localhost>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
	 <1230165163.7292.32.camel@pasglop>
	 <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
	 <1231158516.8367.3.camel@localhost>
Content-Type: text/plain
Date: Tue, 06 Jan 2009 23:05:25 +1100
Message-Id: <1231243525.14860.26.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-01-05 at 23:28 +1100, Michael Ellerman wrote:
> I'm confused. Which code never exercises which path, and so what
> deserves a better look?

Well, the thing is with the fix that went into 2.6.30, some error path
will never bit hit, or pretty much.

Without the fix, what can happen is that a syscall incorrectly is
interpreted as returning an error, thus triggering rarely used error
path in Mono. However, that shouldn't lockup the whole machine :-)

So It's still worth investigating what's happening when taking the fix
out, as we may have another bug somewhere lurking.

Cheers,
Ben.

