Return-Path: <linux-kernel-owner+w=401wt.eu-S1752733AbXJVEK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbXJVEK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 00:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750781AbXJVEKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 00:10:50 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbXJVEKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 00:10:49 -0400
Date: Mon, 22 Oct 2007 00:10:45 -0400
From: Rik van Riel <riel@redhat.com>
To: Roel Kluin <12o3l@tiscali.nl>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] unlock before bug returns
Message-ID: <20071022001045.131ea465@bree.surriel.com>
In-Reply-To: <471C11E5.2000003@tiscali.nl>
References: <471C0697.1040906@tiscali.nl>
	<471C11E5.2000003@tiscali.nl>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 04:58:45 +0200
Roel Kluin <12o3l@tiscali.nl> wrote:

> Roel Kluin wrote:
> 
> >     unlock before bug returns
> 
> >  	if (cs >= GPMC_CS_NUM || !gpmc_cs_reserved(cs)) {
> >  		printk(KERN_ERR "Trying to free non-reserved GPMC
> > CS%d\n", cs);
> > -		BUG();
> >  		spin_unlock(&gpmc_mem_lock);
> > -		return;
> > +		BUG();
> 
> 
> should we bother to unlock before panicking, or is the unlock not
> required either?

BUG() kills the current process, but not the whole system.

Unlocking the lock means that the rest of the system has somewhat
of a chance of surviving.  Not unlocking means a guaranteed hang
for the rest of the system, making a BUG() no better than panic.

Please keep the unlock.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
