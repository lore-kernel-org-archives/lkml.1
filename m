Return-Path: <linux-kernel-owner+w=401wt.eu-S1760441AbZAGTJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760441AbZAGTJm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:09:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZAGTJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:09:33 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44470 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbZAGTJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:09:32 -0500
Date: Wed, 7 Jan 2009 13:09:12 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: jmorris@namei.org, akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [TOMOYO #14 (mmotm 2008-12-30-16-05) 02/10] Singly linked list
	implementation.
Message-ID: <20090107190912.GB20311@us.ibm.com>
References: <20090101050741.372438529@I-love.SAKURA.ne.jp> <20090101050939.802554261@I-love.SAKURA.ne.jp> <alpine.LRH.1.10.0901051926130.16049@tundra.namei.org> <200901060813.n068DI3Y023188@www262.sakura.ne.jp> <alpine.LRH.1.10.0901062008480.25091@tundra.namei.org> <200901070636.n076aFY0061512@www262.sakura.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901070636.n076aFY0061512@www262.sakura.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tetsuo Handa (penguin-kernel@i-love.sakura.ne.jp):
> James Morris wrote:
> > > Not all structures listed below are used as singly linked list,
> > > but many of them are used as singly linked list.
> > 
> > Can any of these be converted to your singly linked list implementation ?
> 
> Maybe, but will be few.
> 
> Regular singly linked list (which is known as "slist") implementation has
> below characteristics.
> 
>  (1) Supports "add", "read" and "remove" operations.
>  (2) Caller holds read lock when reading, and holds write lock when adding or
>      removing.
>  (3) Iteration method (for_each_*) needn't to call rcu_dereference() because
>      caller holds locks as needed.
> 
> TOMOYO's singly linked list (which is named as "list1") implementation has
> below characteristics.
> 
>  (1) Supports "add" and "read" operations.
>  (2) Caller holds a lock when adding, but doesn't hold a lock when reading.
>  (3) Iteration method (for_each_*) needs to call rcu_dereference() because
>      caller doesn't hold a lock when reading.
> 
> I think it is not a good thing to rename "list1" to "slist".

How about alist (or aolist) for append-only list?

The problem with list1 is that it *really* doesn't imply the
characteristics you cite.

-serge
