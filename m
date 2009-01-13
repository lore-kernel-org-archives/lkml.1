Return-Path: <linux-kernel-owner+w=401wt.eu-S1758021AbZAMTDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758021AbZAMTDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZAMTDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:03:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52724 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZAMTDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:03:32 -0500
Message-ID: <496CE567.1040808@zytor.com>
Date: Tue, 13 Jan 2009 11:03:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to	userspace
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <496CE234.2070900@zytor.com> <20090113185239.GC14470@localhost> <496CE3A2.4060605@zytor.com> <20090113190007.GA16663@localhost>
In-Reply-To: <20090113190007.GA16663@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> | > | 
> | > | You can introduce symbols into the general namespace if *and only if*
> | > | they are in a header file that is invoked directly by the user.  In
> | > | other words, such a header file is unusable by libc, but setup.h doesn't
> | > | contain anything needed by libc in the first place.
> | > | 
> | > | 	-hpa
> | > | 
> | > 
> | > So we could just fence it by __KERNEL__?
> | > 
> | 
> | We might, as userspace shouldn't need COMMAND_LINE_SIZE anyway (see
> | other post), but I'm rather confused as how you got that from what I
> | wrote above.
> | 
> 
> The thing is that kernel headers are not only touched by libc.
> Someone could write a program and include setup.h there.
> Or I translated you wrong :)
> 

My whole point was that there are classes of symbols which may be
legitimately used by userspace *applications*, but not by libc.  Those
can live in the general namespace since they are included by explicit
user command.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

