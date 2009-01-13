Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbZAMTAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbZAMTAi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 14:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753702AbZAMTAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 14:00:10 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:51552 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZAMTAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 14:00:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bNyICZMuKurTV20ibOY6skeUULIrQ701s+P3eZjeDL+SSu2arOASLDPtxHzG3adLpm
         18h1LqyJfJrBYYjqChpEB+tlFyVbPjXztT7PMmuBkN9vO0fhdEawTVNpJVxRLACwtVlK
         bSyaC/N8135ujEG9nktXfGZUv9vckpYHp7rDk=
Date: Tue, 13 Jan 2009 22:00:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [PATCH -tip] x86: headers - fix export private data to
	userspace
Message-ID: <20090113190007.GA16663@localhost>
References: <20090113183456.GA14470@localhost> <1231871832.16221.1.camel@brick> <496CE234.2070900@zytor.com> <20090113185239.GC14470@localhost> <496CE3A2.4060605@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496CE3A2.4060605@zytor.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[H. Peter Anvin - Tue, Jan 13, 2009 at 10:55:30AM -0800]
| Cyrill Gorcunov wrote:
| > | > 
| > | >> 4) setup.h - COMMAND_LINE_SIZE saved for userspace, bootloaders
| > | >>    could use it.
| > | > 
| > | > Doesn't this need to be (at least) _COMMAND_LINE_SIZE to avoid
| > | > polluting the namespace, not sure it can be changed though as the
| > | > horse is already out of the barn.
| > | 
| > | No, this is not one of those cases, but it's worth explaining why.
| > | 
| > | You can introduce symbols into the general namespace if *and only if*
| > | they are in a header file that is invoked directly by the user.  In
| > | other words, such a header file is unusable by libc, but setup.h doesn't
| > | contain anything needed by libc in the first place.
| > | 
| > | 	-hpa
| > | 
| > 
| > So we could just fence it by __KERNEL__?
| > 
| 
| We might, as userspace shouldn't need COMMAND_LINE_SIZE anyway (see
| other post), but I'm rather confused as how you got that from what I
| wrote above.
| 
| 	-hpa
| 
| -- 
| H. Peter Anvin, Intel Open Source Technology Center
| I work for Intel.  I don't speak on their behalf.
| 

The thing is that kernel headers are not only touched by libc.
Someone could write a program and include setup.h there.
Or I translated you wrong :)

		- Cyrill -
