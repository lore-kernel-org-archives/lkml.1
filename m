Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYJEJe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYJEJe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 05:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752902AbYJEJeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 05:34:22 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:51627 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbYJEJeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 05:34:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=RkRKu8Y2p5zKXkKPSRIMdEmyHhWQYt45gbiJP8oL7pGgovuC/5WzGLyQyK85MlO8US
         klHPFBHVmQV19xHey9eqVt0jZg3lRY6xtsodmPYYG3VfxQPKjv5pf2FBX5q58XsuTYeD
         G+UihB+1iadQOi7hcWbTggwbURUpCOusz2SWQ=
Message-ID: <48E88A15.1010205@panasas.com>
Date: Sun, 05 Oct 2008 11:34:13 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BD626B.6070705@panasas.com> <200810021535.36302.rusty@rustcorp.com.au>
In-Reply-To: <200810021535.36302.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 03 September 2008 01:57:31 Boaz Harrosh wrote:
>> +#define BUILD_BUG_ON(e) \
>> +       do { struct {int:-!!(e); } x __maybe_unused;} while(0)
> 
> Why did you hate the void cast again?  Simplest should 
> be "(void)BUILD_BUG_ON_ZERO(e)".  But if not, it seems to me that it's 
> cleaner to do:
> 
> #define BUILD_BUG_ON(e) \
> 	do { } while(BUILD_BUG_ON_ZERO(e))
> 

I have not checked this exact variant, but the problems I had
is that wrong or non-const code was ignored by the compiler,
which is what I tried to solve.

> No chance of the compiler emitting unused vars.
> 

There is no unused vars because the result is a zero-sized
struct which will never emit any code.

> Cheers,
> Rusty.
> 

Is it that important? the code submitted does what is required
to the letter, should we spend more effort on this?

Boaz
 
