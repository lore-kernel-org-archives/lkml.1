Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYJOPd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYJOPd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbYJOPdt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:33:49 -0400
Received: from el-out-1112.google.com ([209.85.162.179]:18182 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbYJOPds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:33:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=COrDMhK0gadu5BC44XCTZES+KP9qIk3Mfe6d5qLyKQw377SsLwo3pXuo8NgMDQmwet
         unHjtHSjAiFwozUpfhXWc5lNMxjFQ5vAOP+r/vEMGzLuBXT8DxwTZ/0PQyIBQdhJupvW
         xw5+o0TnzZuGnmtWNTTyrajnopG37dcThegug=
Message-ID: <48F60D56.6040209@gmail.com>
Date: Wed, 15 Oct 2008 17:33:42 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: GIT head no longer boots on x86-64
References: <alpine.LFD.2.00.0810130752020.3288@nehalem.linux-foundation.org> <1223910693-28693-1-git-send-email-jirislaby@gmail.com> <20081013164717.7a21084a@lxorguk.ukuu.org.uk> <20081015115153.GA16413@elte.hu> <alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0810150758310.3288@nehalem.linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2008 05:06 PM, Linus Torvalds wrote:
> On Wed, 15 Oct 2008, Ingo Molnar wrote:
>> Queued the fix below up in tip/x86/urgent for a merge to Linus later 
>> today. Thanks!
> 
> Please don't send this crap to me.
> 
> Guys, _look_ at the patch for one second. And then tell me it isn't crap. 

Not in my eyes.

> The question is: "Is this a vmalloc'ed area?". That's the name of the 
> function. AND YOU JUST BROKE IT!

Modules area is vmalloc'ed on x86; on x86_64 only in different virtual address
space area. So returning true from is_vmalloc_addr() for this space looks very
sane to me, as it was on x86_32 for years.

Users usually do
is_vmalloc_addr(a) ? vfree(a) : kfree(a);
Even there it makes more sense to me.

However I'm fine with introducing is_module_addr() alike function for x86 to
check the general modules space bounds on x86_64 and return is_vmalloc_addr() on
x86_32. Does this look better?
