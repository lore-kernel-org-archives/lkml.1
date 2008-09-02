Return-Path: <linux-kernel-owner+w=401wt.eu-S1753748AbYIBHq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748AbYIBHq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 03:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751541AbYIBHqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 03:46:18 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:54993 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYIBHqS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 03:46:18 -0400
Message-Id: <48BD0BB5.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Tue, 02 Sep 2008 08:47:33 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Boaz Harrosh" <bharrosh@panasas.com>
Cc: "David S. Miller" <davem@davemloft.net>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ivo van Doorn" <IvDoorn@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Theodore Tso" <tytso@mit.edu>, "Rusty Russell" <rusty@rustcorp.com.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] debug: BUILD_BUG_ON: error on non-const
	 expressions
References: <48BBE77D.7070007@panasas.com> <48BBEE04.30903@panasas.com>
 <48BC1065.76E4.0078.0@novell.com> <48BBFA67.9070305@panasas.com>
 <48BC1A10.76E4.0078.0@novell.com> <48BC037F.5010305@panasas.com>
 <48BC267E.76E4.0078.0@novell.com> <48BC1B31.1050306@panasas.com>
In-Reply-To: <48BC1B31.1050306@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 18:41 >>>
>Jan Beulich wrote:
>>>>> Boaz Harrosh <bharrosh@panasas.com> 01.09.08 17:00 >>>
>>> What is broken with my BUILD_BUG_ON_ZERO(). I tried all tests and
>>> it works fine. Do you have a test with unwanted results?
>>> (Actually it's the original one I have not touched it).
>> 
>> That's the problem - it uses the same sizeof(char[]) approach, and hence
>> has the same problems that you just try to fix for BUILD_BUG_ON().
>> 
>
>No it does not have this problem. Have you tested it? 
>I have! It works fine. (Complains on non-const expressions)

For static variables, yes. But not for automatic variables and the like:

#define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)

int test(int i) {
	int x = BUILD_BUG_ON_ZERO(i);

	return x;
}

You could argue that I could place a simple BUILD_BUG_ON() later in
the code, but that easily defeats the documentation purposes the
construct also has (my general position on this is that the check should
be in or immediately before the statement that depends on the
enforced restriction).

Jan

