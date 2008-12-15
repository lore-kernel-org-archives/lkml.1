Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbYLOUCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbYLOUCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 15:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYLOUCE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 15:02:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:46306
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752783AbYLOUCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 15:02:03 -0500
Date: Mon, 15 Dec 2008 12:02:04 -0800 (PST)
Message-Id: <20081215.120204.257704544.davem@davemloft.net>
To: ralf@linux-mips.org
Cc: kraxel@redhat.com, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v3 0/3] preadv & pwritev syscalls.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081215160311.GA23153@linux-mips.org>
References: <1229340977-24345-1-git-send-email-kraxel@redhat.com>
	<20081215160311.GA23153@linux-mips.org>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ralf Baechle <ralf@linux-mips.org>
Date: Mon, 15 Dec 2008 16:03:11 +0000

> On Mon, Dec 15, 2008 at 12:36:14PM +0100, Gerd Hoffmann wrote:
> 
> > Next revision of the patch series, with the alignment issue fixed by
> > swapping the last two arguments as suggested by arch maintainers.
> > 
> > I've dropped the now-obsolete wrappers for mips.  Ralf, please
> > double-check.
> 
> It fixes the alignment issue but still won't work; on MIPS 32-bit userspace
> will pass the 64-bit argument in two registers but the 64-bit kernel code
> will assume it to be passed in a single registers.

Same on 32-bit sparc, and I assume 32-bit powerpc as well.

> I'm surprised this works for x86; does x86-64 code really expect 64-bit
> arguments as 2 32-bit arguments?

Args get pushed onto the stack, so perhaps it works by accident :)
