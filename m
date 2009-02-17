Return-Path: <linux-kernel-owner+w=401wt.eu-S1754369AbZBQLk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369AbZBQLk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 06:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbZBQLkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 06:40:49 -0500
Received: from jurassic.park.msu.ru ([195.208.223.243]:52271 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbZBQLks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 06:40:48 -0500
Date: Tue, 17 Feb 2009 14:40:56 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Richard Henderson <rth@twiddle.net>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] alpha: binfmt_aout fix
Message-ID: <20090217114054.GA26176@jurassic.park.msu.ru>
References: <20090217104956.GC25856@jurassic.park.msu.ru> <20090217110842.GA22272@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217110842.GA22272@infradead.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 17, 2009 at 06:08:42AM -0500, Christoph Hellwig wrote:
> I think the proper fix for this is to make sure newly registered
> binfmts are added to the tail of the list, not the front.

Yes, I was thinking about that. But then I need to make sure
that alpha binfmt_loader is registered first, which is not
possible at the moment as binfmts get registered at core_initcall
level.
If it's acceptable to change binfmts initcall level to, say,
fs_initcall, then changing list_add() to list_add_tail() would
certainly work fine here.

Ivan.
