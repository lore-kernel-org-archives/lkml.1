Return-Path: <linux-kernel-owner+w=401wt.eu-S1760246AbYBZLkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760246AbYBZLkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 06:40:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbYBZLkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 06:40:13 -0500
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:47338 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYBZLkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 06:40:11 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 06:40:11 EST
Message-ID: <47C3F8F1.4010100@kernel.org>
Date: Tue, 26 Feb 2008 03:33:05 -0800
From: Josh Triplett <josh@kernel.org>
User-Agent: Mozilla-Thunderbird 2.0.0.9 (X11/20080110)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: fbuihuu@gmail.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org
Subject: Re: + rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
 added to -mm tree
References: <200802230734.m1N7Ymrp018304@imap1.linux-foundation.org>
In-Reply-To: <200802230734.m1N7Ymrp018304@imap1.linux-foundation.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[I did not see this patch go by on any mailing list, so I replied to
the -mm mail and CCed LKML.]

akpm@linux-foundation.org wrote:
> The patch titled
>      rcu: split list.h and move rcu-protected lists into rculist.h
> has been added to the -mm tree.  Its filename is
>      rcu-split-listh-and-move-rcu-protected-lists-into-rculisth.patch
[...]
> Subject: rcu: split list.h and move rcu-protected lists into rculist.h
> From: Franck Bui-Huu <fbuihuu@gmail.com>
> 
> Move rcu-protected lists from list.h into a new header file rculist.h.
> 
> This is done because list are a very used primitive structure all over the
> kernel and it's currently impossible to include other header files in this
> list.h without creating some circular dependencies.
> 
> For example, list.h implements rcu-protected list and uses rcu_dereference()
> without including rcupdate.h.  It actually compiles because users of
> rcu_dereference() are macros.  Others RCU functions could be used too but
> aren't probably because of this.
> 
> Therefore this patch creates rculist.h which includes rcupdates without to
> many changes/troubles.
> 
> Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Josh Triplett <josh@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This seems fine to me.  Having the headers separate might make it more
difficult to keep the two in sync, but the list primitives don't
change, so that doesn't really matter much.

Acked-by: Josh Triplett <josh@kernel.org>

- Josh Triplett

