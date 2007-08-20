Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXHTWOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXHTWOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbXHTWOM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:14:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:57986 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbXHTWOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:14:11 -0400
To: Christoph Lameter <clameter@sgi.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 7/7] Switch of PF_MEMALLOC during writeout
References: <20070820215040.937296148@sgi.com>
	<20070820215317.441134723@sgi.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 21 Aug 2007 01:08:06 +0200
In-Reply-To: <20070820215317.441134723@sgi.com>
Message-ID: <p73ps1hztwp.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter <clameter@sgi.com> writes:

> Switch off PF_MEMALLOC during both direct and kswapd reclaim.
> 
> This works because we are not holding any locks at that point because
> reclaim is essentially complete. The write occurs when the memory on
> the zones is at the high water mark so it is unlikely that writeout
> will get into trouble. If so then reclaim can be called recursively to
> reclaim more pages.

What would stop multiple recursions in extreme low memory cases? Seems 
risky to me and risking stack overflow.  Perhaps define another flag to catch that?

-Andi
