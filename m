Return-Path: <linux-kernel-owner+w=401wt.eu-S1755689AbZHURlt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689AbZHURlt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 13:41:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZHURls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 13:41:48 -0400
Received: from mail.gmx.net ([213.165.64.20]:34828 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752770AbZHURlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 13:41:47 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19HZJJ1NshHYAEt9/9qdfdlfkWhwRMMmPzd04f3EQ
	lTXbdXVn78g+HV
Message-ID: <4A8EDC71.10403@gmx.de>
Date: Fri, 21 Aug 2009 19:42:09 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fb: do not ignore fb_set_par errors
References: <1250769597-14861-1-git-send-email-FlorianSchandinat@gmx.de>	<1250769597-14861-2-git-send-email-FlorianSchandinat@gmx.de> <20090820153100.eec12070.akpm@linux-foundation.org>
In-Reply-To: <20090820153100.eec12070.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton schrieb:
> On Thu, 20 Aug 2009 11:59:56 +0000
> Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> 
>> at the moment about half of the framebuffer drivers can return an error
>> code in fb_set_par. Until now it would be silently ignored by fbmem.c
>> and fbcon.c. The following patch fixes fbmem.c to pass it on but I have
>> no idea what the right behaviour in fbcon.c would look like.
>> Any comments?
> 
> Nobody really maintains this code any more and I don't know to whom
> your question should be addressed.  All I can suggest is that you
> decide what is the best path to take, and propose that we take it!  

Okay. I think it's difficult to ensure that we always end up with a 
working console. I assume that this is a very very rare case and as a 
start it should be enough to detect those cases and print an error message.

> Yes, it seems reasonable to me - if we ignore this the machine will
> probably crash later anyway.
> 
> A well-behaved driver should leave the hardware in an unchanged state
> if it's going to return an error (IMO).
> 
> Do you know of any bug reports which are due to this lack of checking?

No, I just hit the problem by thinking about how dynamic errors can be 
handled and looking at some drivers and fbmem.c.

> If you're concerned about the effects of this change, perhaps you
> should add a nice big printk when we decide to error out, so that it
> makes it easier for bug reporters (and responders!) to work out what
> happened?

That's a very good idea. Will add this too and resend the patch.


Thanks,

Florian Tobias Schandinat
