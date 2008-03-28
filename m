Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYC1VR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYC1VR1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755114AbYC1VRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:17:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34376 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757517AbYC1VRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:17:08 -0400
Date: Fri, 28 Mar 2008 21:17:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: use of volatile in iounmap()?
Message-ID: <20080328211707.GD10722@ZenIV.linux.org.uk>
References: <20080328203427.GA14256@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080328203427.GA14256@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2008 at 09:34:28PM +0100, Sam Ravnborg wrote:
> While reviewing some CAN driver I stumbled on iounmap
> which has following prototype on x86:
> 
> extern void iounmap(volatile void __iomem *addr);
> 
> I argued that the driver should not use volatile
> but then I cannot explain why the argument to
> iounmap takes a volatile.
> 
> The same goes for many other functions in
> the io*.h headers.
> 
> Grepping the other archs they mostly follow
> same pattern.
> 
> Can anyone explain the rational for volatile in this case.

"Passing a pointer to volatile is allowed, along with passing pointers
to unqualified".
