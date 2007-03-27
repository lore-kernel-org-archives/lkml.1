Return-Path: <linux-kernel-owner+w=401wt.eu-S1750700AbXC0HuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750700AbXC0HuH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 03:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750717AbXC0HuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 03:50:07 -0400
Received: from smtp.osdl.org ([65.172.181.24]:43976 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750700AbXC0HuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 03:50:05 -0400
Date: Mon, 26 Mar 2007 23:49:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch resend v4] update ctime and mtime for mmaped write
Message-Id: <20070326234957.6b287dda.akpm@linux-foundation.org>
In-Reply-To: <E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
References: <E1HVZyn-0008T8-00@dorka.pomaz.szeredi.hu>
	<20070326140036.f3352f81.akpm@linux-foundation.org>
	<E1HVwy4-0002UD-00@dorka.pomaz.szeredi.hu>
	<20070326153153.817b6a82.akpm@linux-foundation.org>
	<E1HW5am-0003Mc-00@dorka.pomaz.szeredi.hu>
	<20070326232214.ee92d8c4.akpm@linux-foundation.org>
	<E1HW6Ec-0003Tv-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Mar 2007 09:36:50 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:

> > There is surely no need to duplicate all that.
> 
> Yeah, we could teach generic_writepages() to conditionally not submit
> for io just test/clear pte dirtyness.
> 
> Maybe that would be somewhat cleaner, dunno.
> 
> Then there are the ram backed filesystems, which don't have dirty
> accounting and radix trees, and for which this pte walking is still
> needed to provide semantics consistent with normal filesystems.

hm.

I don't know how important all this is, really - we've had this bug for
ever and presumably we've already trained everyone to work around it.

What usage scenarios are people actually hurting from?  Is there anything
interesting in the mysterious Novell Bugzilla #206431?

Perhaps we can get away with doing something half-assed which covers most
requirements...
