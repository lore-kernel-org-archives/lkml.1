Return-Path: <linux-kernel-owner+w=401wt.eu-S1754190AbYJCBbu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbYJCBbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 21:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbYJCBbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 21:31:20 -0400
Received: from ozlabs.org ([203.10.76.45]:60470 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754344AbYJCBbT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 21:31:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const expressions
Date: Thu, 2 Oct 2008 15:35:35 +1000
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>, "David S. Miller" <davem@davemloft.net>,
       Ivo van Doorn <IvDoorn@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com> <48BD626B.6070705@panasas.com>
In-Reply-To: <48BD626B.6070705@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810021535.36302.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2008 01:57:31 Boaz Harrosh wrote:
> +#define BUILD_BUG_ON(e) \
> +       do { struct {int:-!!(e); } x __maybe_unused;} while(0)

Why did you hate the void cast again?  Simplest should 
be "(void)BUILD_BUG_ON_ZERO(e)".  But if not, it seems to me that it's 
cleaner to do:

#define BUILD_BUG_ON(e) \
	do { } while(BUILD_BUG_ON_ZERO(e))

No chance of the compiler emitting unused vars.

Cheers,
Rusty.

