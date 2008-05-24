Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbYEXSwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbYEXSwa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 14:52:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757114AbYEXSwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 14:52:19 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49579 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755824AbYEXSwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 14:52:18 -0400
Date: Sat, 24 May 2008 12:52:01 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: some numbers on macros
Message-ID: <20080524185201.GZ2638@parisc-linux.org>
References: <200805241748.19607.m.kozlowski@tuxland.pl> <20080524093350.60e6dc8d@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080524093350.60e6dc8d@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 24, 2008 at 09:33:50AM -0700, Arjan van de Ven wrote:
> unused macros in common header files are an indication of stale APIs
> otoh.. and might be of some interest. (Same for static inline in
> headers)

Possibly.  There's likely to be a lot of macros unused like these ones:

#define  PCI_X_CMD_MAX_READ     0x000c  /* Max Memory Read Byte Count */
                                /* Max # of outstanding split transactions */
#define  PCI_X_CMD_SPLIT_1      0x0000  /* Max 1 */
#define  PCI_X_CMD_SPLIT_2      0x0010  /* Max 2 */
#define  PCI_X_CMD_SPLIT_3      0x0020  /* Max 3 */
...

where the macros embody the PCI specification in code -- possibly we
don't use them yet, but if we ever did, we'd have the macros to use.

Another category of false positive is macros that ought to be used,
but the code that ought to be using them has decided to go its own way.
That still indicates a bug, but not the one you might initially think.

In summary, this is probably an interesting exercise, but the results
would need to be interpreted with care.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
