Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYLLVlw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYLLVlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:41:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYLLVln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:41:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:6517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbYLLVlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:41:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AFTSid8sMgANjuJJvwkrFC71WtUAZDbGQFTv+uj+xWSDZlWgqQVqrfUk/Drtsv/wWV
         ku00jiLO1Y5Oy5SlcALDlrT1a6Acm19b3CfrWHJYhghtTlF1dsjRE9gQSlHyQAFYW3Jd
         FL5Q3ByiGm+jTpXIFEEyIA+XW+mgKp7KWJtbo=
Date: Sat, 13 Dec 2008 00:41:37 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>, Steven Rostedt <srostedt@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander van Heukelum <heukelum@fastmail.fm>,
       fweisbec <fweisbec@gmail.com>
Subject: Re: [RFC] x86: entry_64 - introduce FTRACE_ frame macro
Message-ID: <20081212214137.GB731@localhost>
References: <20081212184136.GB14192@localhost> <1229113167.32623.12.camel@localhost.localdomain> <20081212204724.GA26194@localhost> <alpine.DEB.1.10.0812121552360.19351@gandalf.stny.rr.com> <20081212205729.GA28554@localhost> <alpine.DEB.1.10.0812121620520.19351@gandalf.stny.rr.com> <20081212213538.GA731@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081212213538.GA731@localhost>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Cyrill Gorcunov - Sat, Dec 13, 2008 at 12:35:38AM +0300]
| 
...
| | Why add assembly condition? We only want this if CONFIG_FUNCTION_TRACER 
| | is enabled, right?  We could combine it with the current #ifndef inside 
| | the CONFIG_FUNCTION_TRACER. But I would make do:
| | 
| | #ifdef __ASSEMBLY__
| | <your stuff>
| | #else
| | < C stuff >
| | #endif
| | 
| | -- Steve
| 
| Steve, here is how it could look like:
| (I liked first proposal more :)

If you meant to put them under CONFIG_FUNCTION_TRACER only it would
lead to more hard to parse by human representation I believe :)
That is why I put __ASSEMBLY__ in that way (I mean only two sections
__ASSEMBLY__ and #else and all original stuff here) Btw there was an
error in ftrace.h. Iirc gas know nothing about (long) so MCOUNT_ADDR
should be under #ifndef actually. But that is not that serious since
we dont use it now in *.S (don't we?).

		- Cyrill -
