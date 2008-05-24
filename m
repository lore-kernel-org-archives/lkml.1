Return-Path: <linux-kernel-owner+w=401wt.eu-S1756805AbYEXXlZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756805AbYEXXlZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 19:41:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYEXXlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 19:41:15 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:46633 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYEXXlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 19:41:14 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: some numbers on macros
Date: Sun, 25 May 2008 01:41:09 +0200
User-Agent: KMail/1.9.9
Cc: Arjan van de Ven <arjan@infradead.org>, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200805241748.19607.m.kozlowski@tuxland.pl> <20080524093350.60e6dc8d@infradead.org> <20080524185201.GZ2638@parisc-linux.org>
In-Reply-To: <20080524185201.GZ2638@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805250141.09195.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Sat, May 24, 2008 at 09:33:50AM -0700, Arjan van de Ven wrote:
> > unused macros in common header files are an indication of stale APIs
> > otoh.. and might be of some interest. (Same for static inline in
> > headers)
> 
> Possibly.  There's likely to be a lot of macros unused like these ones:

Maybe I wasn't precise enough. The script looks for macros which take argument(s)
i.e.

#define foobar() ...

> #define  PCI_X_CMD_MAX_READ     0x000c  /* Max Memory Read Byte Count */
>                                 /* Max # of outstanding split transactions */
> #define  PCI_X_CMD_SPLIT_1      0x0000  /* Max 1 */
> #define  PCI_X_CMD_SPLIT_2      0x0010  /* Max 2 */
> #define  PCI_X_CMD_SPLIT_3      0x0020  /* Max 3 */
> ...
> 
> where the macros embody the PCI specification in code -- possibly we
> don't use them yet, but if we ever did, we'd have the macros to use.

Agreed.

> Another category of false positive is macros that ought to be used,
> but the code that ought to be using them has decided to go its own way.
> That still indicates a bug, but not the one you might initially think.

Agreed.

> In summary, this is probably an interesting exercise, but the results
> would need to be interpreted with care.

Well I'll just go through some of them. This is long term task as its number is quite
big. Maybe I can improve the script some more or apply some other measures. I guess
one can find there all sort of macros and some part of them are leftovers from something
that was there some time ago.

Interesting part would be to write a 'parser' that actually sees the context and understands
cpp directives, that could 'walk' the tree.

	Mariusz
