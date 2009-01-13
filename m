Return-Path: <linux-kernel-owner+w=401wt.eu-S1754461AbZAMTNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461AbZAMTNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:13:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbZAMTM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:12:56 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:40957 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbZAMTMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:12:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vQx0EKrolFIo7p658gfmtgcU3UGJ/VJngeSZ/s5nUtL/PQcNQ0sd6HALomP5MJXe9q
         Sql2LB2JSJt8f3b3D6Jlkr10Rq7nhaDgEVXwoDJxijiE/PGiAtjmZEY8UxSBzQ6HzJV9
         nnx/3c6GTiom7tl3LvhwWs8cju67oPWDEsjVw=
Date: Tue, 13 Jan 2009 22:12:53 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090113191253.GB16663@localhost>
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <496CE234.2070900@zytor.com> <20090113185239.GC14470@localhost> <496CE3A2.4060605@zytor.com> <20090113190007.GA16663@localhost> <496CE567.1040808@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496CE567.1040808@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, Jan 13, 2009 at 11:03:03AM -0800]
| Cyrill Gorcunov wrote:
| > | > | 
| > | > | You can introduce symbols into the general namespace if *and only if*
| > | > | they are in a header file that is invoked directly by the user.  In
| > | > | other words, such a header file is unusable by libc, but setup.h doesn't
| > | > | contain anything needed by libc in the first place.
| > | > | 
| > | > | 	-hpa
| > | > | 
| > | > 
| > | > So we could just fence it by __KERNEL__?
| > | > 
| > | 
| > | We might, as userspace shouldn't need COMMAND_LINE_SIZE anyway (see
| > | other post), but I'm rather confused as how you got that from what I
| > | wrote above.
| > | 
| > 
| > The thing is that kernel headers are not only touched by libc.
| > Someone could write a program and include setup.h there.
| > Or I translated you wrong :)
| > 
| 
| My whole point was that there are classes of symbols which may be
| legitimately used by userspace *applications*, but not by libc.  Those
| can live in the general namespace since they are included by explicit
| user command.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

That is why I didn't fence COMMAND_LINE_SIZE by __KERNEL__ initialy
and thought about if LILO could had been using it. Then I found a
post in old-dated LKML that LILO has its own definition for
such a symbol, then I asked you about boot protocol. I just
didn't understand why you're confused but nevermind :)

		- Cyrill -
