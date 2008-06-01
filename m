Return-Path: <linux-kernel-owner+w=401wt.eu-S1751462AbYFAIBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462AbYFAIBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 04:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbYFAIA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 04:00:57 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:51254 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYFAIAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 04:00:54 -0400
Message-ID: <484256AA.3000709@cs.helsinki.fi>
Date: Sun, 01 Jun 2008 10:58:34 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       David Howells <dhowells@redhat.com>,
       Christoph Lameter <clameter@sgi.com>,
       LKML <linux-kernel@vger.kernel.org>, cooloney@kernel.org,
       akpm@linux-foundation.org, mpm@selenic.com
Subject: Re: [PATCH] nommu: fix kobjsize() for SLOB and SLUB
References: <Pine.LNX.4.64.0805281328310.982@schroedinger.engr.sgi.com> <Pine.LNX.4.64.0805281646470.27125@sbz-30.cs.Helsinki.FI> <20080528153648.GA27783@linux-sh.org> <483DBA85.2060502@cs.helsinki.fi> <Pine.LNX.4.64.0805281325260.932@schroedinger.engr.sgi.com> <483DBFC3.1070108@cs.helsinki.fi> <29611.1212066517@redhat.com> <Pine.LNX.4.64.0805291620250.5415@sbz-30.cs.helsinki.fi> <20080529211207.GB13663@linux-sh.org>
In-Reply-To: <20080529211207.GB13663@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

Paul Mundt wrote:
> Not until the page->index bits are killed, otherwise you aren't fixing
> anything. SLOB on nommu with those page->index tests will automatically
> oops today, before or after your patches. Until that's resolved, there's
> no point in pretending like kobjsize() has been "fixed". As no one has
> come up with a valid reason for those tests existing in the first place,
> simply having your patches and killing the BUG_ON()'s seems ok.

Sorry if I'm starting to sound like a broken record, but can you explain 
why removing the ->index bits are safe? I mean, if removing them is 
really okay, that means we don't hit that code path with SLAB at all?

Paul Mundt wrote:
> If we're not going to kill the BUG_ON()'s, then your patches are purely
> cosmetic fixups with no behavioural change -- (ie, nommu is still hosed
> on SLOB with current git).

It fixes nommu with SLUB, doesn't it?

		Pekka
