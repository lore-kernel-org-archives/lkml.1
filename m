Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXISTaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXISTaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754305AbXISTaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:30:15 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:32457 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbXISTaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:30:14 -0400
Date: Wed, 19 Sep 2007 20:29:07 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Mikael Pettersson <mikpe@it.uu.se>
cc: "H. Peter Anvin" <hpa@zytor.com>, james-p@moving-picture.com,
       linux-kernel@vger.kernel.org, aarapov@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH -mm] Don't truncate /proc/PID/environ at 4096 characters
In-Reply-To: <18161.27621.630048.643513@alkaid.it.uu.se>
Message-ID: <Pine.LNX.4.64.0709192023580.13121@blonde.wat.veritas.com>
References: <200709191454.l8JEsAQO010080@harpo.it.uu.se> <46F1475B.5050107@zytor.com>
 <18161.27621.630048.643513@alkaid.it.uu.se>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Sep 2007, Mikael Pettersson wrote:
> H. Peter Anvin writes:
>  > Mikael Pettersson wrote:
>  > > Does /proc/PID/mem even work? If I do `strace cat /proc/PID/mem > /dev/null'
>  > > for a known good PID, the first read() from /proc/PID/mem fails with ESRCH,
>  > 
>  > Of course it does.  Address zero isn't typically mapped.
> 
> Indeed. My bad :-(

No, not quite.  Peter explains why "cat /proc/self/mem" gets EIO,
but you were seeing "cat /proc/other/mem" get ESRCH: that's from
the stringent !MAY_PTRACE || !ptrace_may_attach checks.

Hugh
