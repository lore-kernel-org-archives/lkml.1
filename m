Return-Path: <linux-kernel-owner+w=401wt.eu-S1753218AbYADLi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218AbYADLi6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 06:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbYADLiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 06:38:51 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:57572 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbYADLiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 06:38:50 -0500
Date: Fri, 4 Jan 2008 11:38:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Guillaume Chazarain <guichaz@yahoo.fr>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: advertise new restrictions on /proc/*/maps & /proc/*/smaps
Message-ID: <20080104113847.GZ27894@ZenIV.linux.org.uk>
References: <20080103235150.2870.31703.stgit@localhost.localdomain> <20080103235736.GW27894@ZenIV.linux.org.uk> <20080104121502.2e6ccaa1@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080104121502.2e6ccaa1@inria.fr>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2008 at 12:15:02PM +0100, Guillaume Chazarain wrote:
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > The whole point is that we have to reject it at read() time, not open()
> > time.
> 
> Yes, my patch was a complement to yours to propagate the -EPERM in easy
> cases. As you noted it added restrictions on reading /proc/*/maps, even
> though I found them acceptable.
> 
> How about this instead?
> 
> Maybe you'd prefer to propagate the actual -EPERM from
> __ptrace_may_attach but that would be more invasive.
> 
> Sidenote: do you think a sparse annotation to check IS_ERR/PTR_ERR
> usage would make sense?
> 
> proc: return -EPERM when preventing read of /proc/*/maps
> 
> Return an error instead of successfully reading an empty file.

You are overcomplicating it - if ->start() returns ERR_PTR(), it's over;
read() will fail with that error and that's it.  No need to mess with
->next(), etc. - it'll never see that ERR_PTR(-EPERM).  Drop these chunks
and you've got an ACK...
