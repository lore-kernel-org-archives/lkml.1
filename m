Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbYLKShX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbYLKShX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:37:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756127AbYLKShE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:37:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42899 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbYLKShD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:37:03 -0500
Message-ID: <49415DC3.5060203@zytor.com>
Date: Thu, 11 Dec 2008 10:36:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Brueckl <ib@wupperonline.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Egmont Koblinger <egmont@uhulinux.hu>
Subject: Re: [PATCH] console ASCII glyph 1:1 mapping
References: <4940441e@wupperonline.de> <alpine.LFD.2.00.0812110823320.3340@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0812110823320.3340@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> Hmm. I bounced both your patches to Peter, since they look valid but I 
> want somebody who knows this code better to ack them. 
> 
> Peter - is there somebody else who should double-check these things, or 
> can you ack them?

I should be able to.

For both patches:

Acked-by: H. Peter Anvin <hpa@zytor.com>

[Let me know if you prefer me setting up a git tree to pull from.]

This was introduced by commit
1ed8a2b3c501bedd4b35130c8a52662ccf78abad, which among other things have
this:

--------
As Behdad pointed out, some fonts (e.g. sun12x22 from the kbd package)
lack Unicode mapping information, hence all you get is lots of question
marks. Though theoretically it's actually a user-space bug (the font
should be fixed), Behdad and I both believe that it'd be good to work
around in the kernel by re-introducing the fallback solution for ASCII
characters only. This sounds a quite reasonable decision, since all
fonts ship the ASCII characters in the first 128 positions. This way
users won't be surprised by lots of question marks just because s/he
issued a not-so-perfectly parameterized setfont command. As this
fallback is only re-introduced for code points below 128, you still
won't see an accented letter replaced by another, but at least you'll
always get the English letters right.
--------

The implementation was obviously buggy, however.

The statement above is also just plain wrong, since installing a font
with no Unicode table causes a direct-to-font Unicode table to be set up
(0xF0xx for all positions) unless explicitly overridden.

Anyway, I was rather against adding this fallback, because I felt it was
needless complexity to deal with a very explicit user error.
Fortunately, the bug didn't affect any legitimate users.

	-hpa
