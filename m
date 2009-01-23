Return-Path: <linux-kernel-owner+w=401wt.eu-S1758254AbZAWG6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254AbZAWG6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbZAWG6F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:58:05 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33461 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751725AbZAWG6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:58:04 -0500
Date: Thu, 22 Jan 2009 22:57:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: corbet@lwn.net, linux-kernel@vger.kernel.org, andi@firstfloor.org,
       viro@ZenIV.linux.org.uk, oleg@redhat.com, linux-api@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH, RFC] Remove fasync() BKL usage, take 3325
Message-Id: <20090122225713.2b2a02cc.akpm@linux-foundation.org>
In-Reply-To: <20090123055404.GL15750@one.firstfloor.org>
References: <20090115153211.663df310@bike.lwn.net>
	<20090122065104.2787df2d.akpm@linux-foundation.org>
	<20090122221500.4c62aa54@tpl>
	<20090122213105.74142908.akpm@linux-foundation.org>
	<20090123055404.GL15750@one.firstfloor.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Jan 2009 06:54:04 +0100 Andi Kleen <andi@firstfloor.org> wrote:
> > I don't know what "the fasync() problem" is?
> 
> The state needs to be protected while the per driver ->fasync callback
> runs, otherwise the bit can get out of sync with what the driver
> thinks it is.

That's the sort of gem which one thinks might have merited a code comment
and some changelog discussion.

> Mind you imho the best way would be to move the bit manipulation for
> that into the drivers, but that would require to change them all.

Do these mystery drivers do the ->f_flags changes under lock_kernel()?  If
so, they all should be changed to take lock_file_flgs()?

