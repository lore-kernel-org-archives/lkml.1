Return-Path: <linux-kernel-owner+w=401wt.eu-S1031449AbXDJSwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031449AbXDJSwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:52:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031443AbXDJSwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:52:01 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:33781 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031449AbXDJSwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:52:00 -0400
Date: Tue, 10 Apr 2007 20:51:58 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070410185158.GA32259@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <461BC99F.7020604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461BC99F.7020604@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 10:30:07AM -0700, H. Peter Anvin wrote:

> Really?  Why is CJK so much more fundamental than, say, Arabic?

Not more fundamental at all. It's just perhaps easier to "support" (I mean
keep track of the cursor, not to really support them of course).

I can't see any reason why these two scripts should be handled identically:
either support both or none. If it's technically easier to support one and
harder to support the other, why not implement the first now? Maybe someone
will implement the other one later.

Oh! Wait a moment! I haven't yet looked at bidi in Unicode, but taking the
first glimpse it seems to me that U+200E and U+200F control the writing
direction. Currently the kernel already skips 200E and 200F, doesn't print
anything, not even a replacement character (see char/consolemap.c). This
means that RTL is already "supported" at this level: eventually (when RTL
mode is turned off) the cursor stands where it is expected to stand. In
between, you either see the right number of replacement symbols, or (if your
font supports Arabic) you may see the symbols in reverse order. So, after
all, it's not worse at all than what I want to reach with CJK.



-- 
Egmont
