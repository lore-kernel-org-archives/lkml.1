Return-Path: <linux-kernel-owner+w=401wt.eu-S1762620AbXGXRcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762620AbXGXRcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 13:32:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbXGXRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 13:31:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54843 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756434AbXGXRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 13:31:47 -0400
Message-ID: <46A636BB.7020706@zytor.com>
Date: Tue, 24 Jul 2007 10:28:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
References: <20070724153916.GS21668@ftp.linux.org.uk> <46A62F35.2000501@goop.org> <20070724171455.GT21668@ftp.linux.org.uk>
In-Reply-To: <20070724171455.GT21668@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Jul 24, 2007 at 09:56:21AM -0700, Jeremy Fitzhardinge wrote:
>> Al Viro wrote:
>>> 	AFAICS, the patch below should do it for i386; instead of
>>> using a dummy loop to tell gcc that this sucker never returns,
>>> we do
>>> static void __always_inline __noreturn __BUG(const char *file, int line);
>>> containing the actual asm we want to insert and define BUG() as
>>> __BUG(__FILE__, __LINE__).  It looks safe, but I don't claim enough
>>> experience with gcc __asm__ potential nastiness, so...
>>>
>>> Comments, objections?
>>>   
>> Does it work?  When I wrote the BUG code I tried this, but gcc kept
>> warning about "noreturn function returns".  I couldn't work out a way to
>> convince gcc that the asm is the end of the line.
> 
> Works here...

Could it be a gcc version difference?

	-hpa
