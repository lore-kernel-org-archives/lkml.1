Return-Path: <linux-kernel-owner+w=401wt.eu-S1763730AbXHFKhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763730AbXHFKhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 06:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755497AbXHFKhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 06:37:06 -0400
Received: from mail.suse.de ([195.135.220.2]:52668 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760687AbXHFKhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 06:37:04 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Jan Beulich" <jbeulich@novell.com>
Subject: Re: [patches] [PATCH] [1/58] x86: Always flush pages in change_page_attr
Date: Mon, 6 Aug 2007 12:36:59 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, patches@x86-64.org
References: <200707191154.642492000@suse.de> <20070719095444.CFAB114E04@wotan.suse.de> <46B710C5.76E4.0078.0@novell.com>
In-Reply-To: <46B710C5.76E4.0078.0@novell.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708061236.59195.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 August 2007 12:15:01 Jan Beulich wrote:
> But that is still wrong - you're again flushing the page table page rather than
> the data one. Fixing this was the purpose of the patch I had sent, plus the
> broken reference counting used by the reversion logic. Jan

True. The problem is that we can't necessarily use the LRU list_head of the data
pages though; e.g. when the page is mapped to user space.

I guess we might need to go back to wbinvd again.

What was the remaining problem of the reference counting? 

-Andi

