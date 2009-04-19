Return-Path: <linux-kernel-owner+w=401wt.eu-S1758955AbZDSCGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955AbZDSCGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 22:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752552AbZDSCGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 22:06:31 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2620 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZDSCGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 22:06:30 -0400
Subject: Re: RFC: introduce struct ksymbol
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Sam Ravnborg <sam@ravnborg.org>, Steven Rostedt <rostedt@goodmis.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090418160910.GA6212@nowhere>
References: <1239753659-11790-1-git-send-email-fweisbec@gmail.com>
	 <1239771791.32241.6.camel@localhost> <20090415055839.GA12040@elte.hu>
	 <200904152021.41427.rusty@rustcorp.com.au>
	 <1239954933.31728.12.camel@localhost>  <20090418160910.GA6212@nowhere>
Content-Type: text/plain
Date: Sat, 18 Apr 2009 19:05:57 -0700
Message-Id: <1240106757.31116.117.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 18:09 +0200, Frederic Weisbecker wrote:
> The only problem is the end result:
> 
> %pSnosm, %pSno, %pSosm, ...
> 
> One could end up stuck reading such a format, trying
> to guess if the developer wanted to print the symbol +
> "nosm" or something...
> 
> But since I don't see any point in printing nosm directly after
> a symbol... :)

You couldn't do that anymore anyway.

The %p<TYPE> convention already swallows all
alphanumeric characters that immediately follow %p.

vsprintf.c line 1043
		case FORMAT_TYPE_PTR:
			str = pointer(fmt+1, str, end, va_arg(args, void *),
				      spec);
			while (isalnum(*fmt))
				fmt++;
			break;


