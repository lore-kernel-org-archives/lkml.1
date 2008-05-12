Return-Path: <linux-kernel-owner+w=401wt.eu-S1758051AbYELEiL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758051AbYELEiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:38:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYELEh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:37:59 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59419 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbYELEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:37:59 -0400
Date: Mon, 12 May 2008 05:37:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       WANG Cong <wangcong@zeuux.org>
Subject: Re: [Patch 7/9] fs/exec.c: fix wrong return value of
	prepare_binprm()
Message-ID: <20080512043758.GP13907@ZenIV.linux.org.uk>
References: <1210254754206-git-send-email-xiyou.wangcong@gmail.com> <12102548553947-git-send-email-xiyou.wangcong@gmail.com> <20080510193105.GG13907@ZenIV.linux.org.uk> <20080512035643.GE2572@hacking> <20080512040122.GN13907@ZenIV.linux.org.uk> <20080512041534.GG2572@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080512041534.GG2572@hacking>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2008 at 12:15:34PM +0800, WANG Cong wrote:
> And even if it is really "binary is corrupted", then -ENOEXEC is
> better than -EINVAL, isn't it?
> 
> Anyway, kernel_read() may return postive when not success.

???

It returns positives *exactly* on success.  In the case you've quoted
we don't have any problems with read; we do have a problem with _short_
read (i.e. miscalculated field size or truncated binary).  In the case
you've patched we _expect_ a short read; it's normal for short scripts,
to start with.  And we are ready to deal with it - the buffer is prefilled
with zeroes and either we have enough to recognize signature (in which case
we'll find the binfmt handler and let it deal with the entire thing, with
full checks of its own) or we will not, in which case nobody will recognize
the damn thing and that's it.
