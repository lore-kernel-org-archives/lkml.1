Return-Path: <linux-kernel-owner+w=401wt.eu-S1764651AbXF1JIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764651AbXF1JIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 05:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761138AbXF1JIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 05:08:37 -0400
Received: from mail-in-08.arcor-online.net ([151.189.21.48]:46127 "EHLO
	mail-in-08.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760140AbXF1JIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 05:08:36 -0400
In-Reply-To: <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <f5dda736b43865bb40583992bafe7a6b@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Neil Booth <neil@daikokuya.co.uk>, linux-kernel@vger.kernel.org,
       Al Viro <viro@ftp.linux.org.uk>, Josh Triplett <josh@freedesktop.org>,
       linux-sparse@vger.kernel.org
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Date: Thu, 28 Jun 2007 11:08:25 +0200
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> Here are three independently invalid non-ICEs that sparse doesn't
>> diagnose.
>>
>> extern int f(void);
>> enum { cast_to_ptr = (int) (void *) 0 };
>> enum { cast_to_float = (int) (double) 1 };
>
> Those two *really* shouldn't fail. I don't care if the C standard says 
> so,
> that is *fine*.

GCC doesn't guarantee you this, either.

> In particular, "offsetof()" should be portably able to basically be the
> standard #define, which involves an integer cast from a constant 
> pointer.
> That had *better* be a valid constant integer expression, because it's
> very useful.

Yes it's useful.  That's why GCC gives you __builtin_offsetof()
for this purpose.

> And I think standards can go screw themselves, and you can make it an
> error with some "--standard-pedantic" switch or similar.
>
> Standards are just random pieces of paper, for crying out loud! They 
> have
> zero relevance in the end.

Sure, as long as you don't care about compatibility across
compilers, what matters is what the compilers you _do_ use
actually implement.  And note that GCC doesn't guarantee
you much over what the C standard does.  Almost everything
it allows extra is just an implementation side effect.


Segher

