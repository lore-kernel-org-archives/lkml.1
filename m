Return-Path: <linux-kernel-owner+w=401wt.eu-S1763114AbYBLTpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763114AbYBLTpn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 14:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751740AbYBLTp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 14:45:29 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59152 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751762AbYBLTp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 14:45:28 -0500
Date: Tue, 12 Feb 2008 11:44:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: linux-kernel@vger.kernel.org, y-goto@jp.fujitsu.com, linux-mm@kvack.org,
       containers@lists.linux-foundation.org, matthltc@us.ibm.com,
       cmm@us.ibm.com
Subject: Re: [PATCH 7/8] Do not recompute msgmni anymore if explicitely set
 by user
Message-Id: <20080212114439.e08085f1.akpm@linux-foundation.org>
In-Reply-To: <47B1B7F4.8080009@bull.net>
References: <20080211141646.948191000@bull.net>
	<20080211141816.094061000@bull.net>
	<20080211122408.5008902f.akpm@linux-foundation.org>
	<47B167AF.6010008@bull.net>
	<20080212014444.8bc3791b.akpm@linux-foundation.org>
	<47B1B7F4.8080009@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2008 16:15:00 +0100
Nadia Derbey <Nadia.Derbey@bull.net> wrote:

> Andrew Morton wrote:
> > On Tue, 12 Feb 2008 10:32:31 +0100 Nadia Derbey <Nadia.Derbey@bull.net> wrote:
> > 
> > 
> >>it builds fine, modulo some changes in ipv4 and ipv6 (see attached patch 
> >>- didn't find it in the hot fixes).
> > 
> > 
> > OK, thanks for checking.  Did you confirm that we don't have unneeded code
> > in vmlinux when CONFIG_PROCFS=n?  I guess before-and-after comparison of
> > the size(1) output would tell us.
> > 
> > Those networking build problems appear to have already been fixed.
> > 
> > In future, please quote the compiler error output in the changelog when
> > sending build fixes or warning fixes, thanks.
> > 
> > 
> > 
> 
> BEFORE:
> 
> lkernel@akt$ size vmlinux
>     text    data     bss     dec     hex filename
> 4318525  454484  462848 5235857  4fe491 vmlinux
> 
> 
> AFTER:
> 
> lkernel@akt$ size vmlinux
>     text    data     bss     dec     hex filename
> 4323161  454484  462848 5240493  4ff6ad vmlinux
> 
> which makes it +4636 = +0.11%
> 
> I've got the details for */built-in.o if needed.
> 

That seems to be a lot of increase.  Are you sure you had CONFIG_PROCFS=n
in both cases?  If so, the patch must have added a lot of code which will
never be executed?

