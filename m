Return-Path: <linux-kernel-owner+w=401wt.eu-S1758778AbXHUBNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758778AbXHUBNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 21:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbXHUBNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 21:13:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34995 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbXHUBNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 21:13:15 -0400
Date: Tue, 21 Aug 2007 03:13:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 7/7] Switch of PF_MEMALLOC during writeout
Message-ID: <20070821011313.GA23935@one.firstfloor.org>
References: <20070820215040.937296148@sgi.com> <20070820215317.441134723@sgi.com> <p73ps1hztwp.fsf@bingen.suse.de> <Pine.LNX.4.64.0708201618060.32662@schroedinger.engr.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708201618060.32662@schroedinger.engr.sgi.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Right. I am not sure exactly how to handle that. There is also the issue 
> of the writes being deferred. I thought maybe of using pdflush to writeout 
> the pages? Maybe increase priority of the pdflush so that it runs 
> immediately when notified. Shrink_page_list would gather the dirty pages 
> in pvecs and then forward to a pdflush. That may make the whole thing much 
> cleaner.

Not sure anything complicated is needed.

You could just add another process flag and set PF_MEMALLOC on the first
recursion?

-Andi
