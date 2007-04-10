Return-Path: <linux-kernel-owner+w=401wt.eu-S1753247AbXDJJna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbXDJJna (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 05:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753281AbXDJJna
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 05:43:30 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:59187 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbXDJJn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 05:43:29 -0400
Date: Tue, 10 Apr 2007 11:43:28 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070410094325.GB9143@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4617DBF7.5060009@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 07, 2007 at 10:59:19AM -0700, H. Peter Anvin wrote:

> As far as width handling -- in order to make all the text line up under 
> all circumstances you need more than width handling.  [...]
> 
> is is ridiculous.  It's much better to draw a line in the sand and say 
> that this is beyond the scope of the in-kernel Linux console.

Hi,

It seems this is the only detail we don't yet agree on and I'd like to come
to an agreement before I update the patch.

I know that correctly handling all Unicode scripts, including CJK, Hebrew,
Arabic, Indic are a much more complicated story and it's way beyond the
scope of kernel. I don't even know whether there's any graphical user-space
application handling all these issues perfectly. So I really don't want to
address them.

I'd like only one small modification: the cursor to jump two columns for CJK
characters instead of just one. (Either two FFFD's, or rather an FFFD
followed by a space printed.) This would allow you to edit English words
within a mixed CJK-English text file. As my experiences show, such a minor
change in the terminal driver would solve cursor aligning issues in *many*
cases. With this change the console would still be very-very far from being
perfect, it just would be simply better in practice.

(Also note that handling two-column characters is probably amongst the first
things a good text editor implements, while handling RTL and other stuff are
trickier for applications too. I guess there are a plenty of text editors
that handle CJK correctly (provided that the underlying terminal emulator
does so too) but have troubles with combining accents, bidi and other more
complicated stuff.)

Are you still definitely against this change? I see no drawbacks this could
cause, while it would make the console better in some circumstances. I think
this is just a small step towards a better console driver.



-- 
Egmont
