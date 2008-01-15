Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbYAOAb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbYAOAb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 19:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbYAOAbu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 19:31:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.234]:55743 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319AbYAOAbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 19:31:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=c41WIYGADUHEVEJyxy9p43nNm2IJeHk8o8qjOZjyAsNE2L6FGh1DlzSShJWifBlT/tmcf2fD7XSkymwIAImEHGiqtA5CbFWXGPFSQKh2f6B0uYQLCOQ0PC/j9bbXK9WXXK7Gv2jpHZF+zjkaFgltTTxAfFqZDGXMwhilg632nDg=
Message-ID: <a8e1da0801141631k50dfd74fo923973722d13c3a3@mail.gmail.com>
Date: Tue, 15 Jan 2008 08:31:48 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <1200307896.5887.42.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>
	 <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>
	 <1200307896.5887.42.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 14, 2008 6:51 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> > The warning that triggered (lockdep.c:700) means that one class (key)
> > was used with more than one name.
>
> Right.
>
> > Looking at cleanup_workqueue_thread(), the lock_acquire() there works on
> > wq->lockdep_map, and that is only initialized at one spot:
> > __create_workqueue_key(), thus it stands to reason that that was
> > mis-used.
>
> Oh ok, yes, makes sense. Maybe something is generating a workqueue with
> a name that's passed in but the key is statically from that place. I'll
> try to find it.

I add some debug printk and found the names :

block_osm/exec_osm

in drivers/message/i2o

maybe this helps.

Regards
dave

>
> johannes
>
