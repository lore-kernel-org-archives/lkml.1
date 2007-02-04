Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXBDBYv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXBDBYv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Feb 2007 20:24:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751841AbXBDBYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Feb 2007 20:24:51 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:7061 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbXBDBYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Feb 2007 20:24:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=GywXc0ZzLfPLJr0p6K/mrXoiRSAndAK7qiUtcYsrQaLYEiyDwF7/mYIyxMulSq/XNQOi3ToOm9Ur7QDV+yE5Wc3rOOdr1g/OnO38HzY33D4r8pgOFV3zjCV/1TY7Kz4iy7j9Fwtz43AfrBBhTP11e9ZE3sTSE7j3MG+S6KI4ghg=
From: Denis Vlasenko <vda.linux@googlemail.com>
To: davids@webmaster.com
Subject: Re: O_NONBLOCK setting "leak" outside of a process??
Date: Sun, 4 Feb 2007 02:22:13 +0100
User-Agent: KMail/1.8.2
Cc: "Philippe Troin" <phil@fifi.org>, linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKGEJJBFAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEJJBFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702040222.13337.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 February 2007 01:55, David Schwartz wrote:
> 
> > That's a bug, right? I couldn't find anything to that effect in IEEE
> > Std. 1003.1, 2004 Edition...
> >
> > Ciao,
> >                      Roland
> 
> It's not a bug, there's no rational alternative. What would two indepedent
> file descriptors for the same end of a TCP connection be?

Easy. O_NONBLOCK should only affect whether read/write blocks or
returns EAGAIN. It's logical for this setting to be per-process.

Currently changing O_NONBLOCK on stdin/out/err affects other,
possibly unrelated processes - they don't expect that *their*
reads/writes will start returning EAGAIN!

Worse, it cannot be worked around by dup() because duped fds
are still sharing O_NONBLOCK. How can I work around this?
--
vda
