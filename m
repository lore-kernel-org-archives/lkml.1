Return-Path: <linux-kernel-owner+w=401wt.eu-S1756167AbZHMUMc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167AbZHMUMc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:12:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755907AbZHMUMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:12:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:42180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZHMUM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:12:26 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=L4PwIA4EgQ5P6M0wVM1ILA3HFmFzIh+4yhnhwMl3IEu54NN0oBkov4DX7XTc2KcSA
	RJa4+jYt/Bl6kVIKOC+gQ==
Date: Thu, 13 Aug 2009 13:12:17 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Amerigo Wang <xiyou.wangcong@gmail.com>
cc: Vincent Li <macli@brc.ubc.ca>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/task_mmu.c v1: fix clear_refs_write() input
 sanity check
In-Reply-To: <20090813084557.GB5663@cr0.nay.redhat.com>
Message-ID: <alpine.DEB.2.00.0908131307001.6485@chino.kir.corp.google.com>
References: <1250119794-8016-1-git-send-email-macli@brc.ubc.ca> <20090813020952.GA5031@cr0.nay.redhat.com> <alpine.DEB.1.00.0908122143060.22452@mail.selltech.ca> <20090813084557.GB5663@cr0.nay.redhat.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Aug 2009, Amerigo Wang wrote:

> >I did the same to other functions, but Andrew pointed out making changes 
> >without fully understanding the patch impact would be risky and break 
> >existing applications, So I need to fully understand what those functions 
> >do before I make any changes.
> > 
> 
> 
> I can't find any strong reason why this one is differernt from others
> in accepting input like "1foo"...
> 

As I already pointed out, there's a patch pending in mmotm that limits the 
write to either 1, 2, or 3, depending on the type of pages the referenced 
bit shall be cleared for associated with the task.

The net effect of Vincent's change is to automatically strip whitespace 
and to remove a needless -EIO error condition at the end of the write 
handler.

It is rather obvious that Vincent's patch is a clear improvement and your 
concern is just a waste of bandwidth.
