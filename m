Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbYIHXlQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbYIHXlQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 19:41:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbYIHXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 19:41:00 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59562 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250AbYIHXk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 19:40:59 -0400
Date: Tue, 9 Sep 2008 00:39:40 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Yoshinori Sato <ysato@users.sourceforge.jp>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Paulo Marques <pmarques@grupopie.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] exclude h8300 local symbols (Re: kallsyms exclude local
 symbols)
In-Reply-To: <87vdx673sw.wl%ysato@users.sourceforge.jp>
Message-ID: <Pine.LNX.4.64.0809090034570.16820@blonde.site>
References: <87fxphzan5.wl%ysato@users.sourceforge.jp> <489AE3C5.2000807@grupopie.com>
 <87zlnotn2l.wl%ysato@users.sourceforge.jp> <20080907235627.293b0a4b.akpm@linux-foundation.org>
 <87vdx673sw.wl%ysato@users.sourceforge.jp>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2008, Yoshinori Sato wrote:
> At Sun, 7 Sep 2008 23:56:27 -0700,
> Andrew Morton wrote:
> > 
> > This patch broke kallsyms on powerpc.  Please see
> > http://ozlabs.org/pipermail/linuxppc-dev/2008-September/062549.html
> 
> Hmm...
> h8300 local symbol head of '.L'.
> But powerpc don't have '.L' pattern.
> I think add condition "str[1] == 'L'".

No, that won't work right on PowerPC if there's function called
something like LookUpTable: we want the symbol ".LookUpTable".

Hugh
