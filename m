Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbYELEyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbYELEyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751991AbYELEyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:54:41 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:37060 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbYELEyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:54:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=UU2purdJB396yFRKg8AzrWvjGDyTp6CRYhQx2t2m2rbKo1f+79WyKBDcnggVr3Lu7tTwF22GEHT85Voef9FpROcCHGXLfwtDHsjB9tZHguNNLtaX1BisaiF1vsD2UWTRPAuYzeNxdwiPXb1B42sy3tIcBTm0gGy5MtmdPyDzYvs=
Date: Mon, 12 May 2008 12:52:33 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: WANG Cong <xiyou.wangcong@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080512045233.GH2572@hacking>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com> <20080510193105.GG13907@ZenIV.linux.org.uk> <20080512035643.GE2572@hacking> <20080512040122.GN13907@ZenIV.linux.org.uk> <20080512041534.GG2572@hacking> <20080512043758.GP13907@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512043758.GP13907@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 05:37:58AM +0100, Al Viro wrote:
>It returns positives *exactly* on success.  In the case you've quoted
>we don't have any problems with read; we do have a problem with _short_
>read (i.e. miscalculated field size or truncated binary).  In the case
>you've patched we _expect_ a short read; it's normal for short scripts,
>to start with.  And we are ready to deal with it - the buffer is prefilled
>with zeroes and either we have enough to recognize signature (in which case
>we'll find the binfmt handler and let it deal with the entire thing, with
>full checks of its own) or we will not, in which case nobody will recognize
>the damn thing and that's it.

Thanks for your detailed explanation.

Since it's expected, it's needless to fix it. :-)

-- 
Hi, I'm a .signature virus, please copy/paste me to help me spread
all over the world.
