Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbYIBQJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbYIBQJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 12:09:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYIBQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 12:09:43 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:22329 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYIBQJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 12:09:43 -0400
Message-Id: <48BD81B4.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 02 Sep 2008 17:11:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "Boaz Harrosh" <bharrosh@panasas.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5 ver2] debug: BUILD_BUG_ON: error on non-const
	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
 <48BD626B.6070705@panasas.com>
In-Reply-To: <48BD626B.6070705@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 02.09.08 17:57 >>>
>-#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
>+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
>+
>+/* Force a compilation error if condition is true */
>+#define BUILD_BUG_ON(e) \
>+	do { struct {int:-!!(e); } x __maybe_unused;} while(0)
 
As indicated before, you should at the very least use __x as the variable
name.

But didn't you have reservations against using a bitfield here? Or was it
really just the void cast on the sizeof() that you disliked?

Jan

