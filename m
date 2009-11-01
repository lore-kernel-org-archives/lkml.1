Return-Path: <linux-kernel-owner+w=401wt.eu-S1752401AbZKAMnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401AbZKAMnD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Nov 2009 07:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZKAMnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Nov 2009 07:43:03 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:40381 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752253AbZKAMnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Nov 2009 07:43:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SkfJ+7JFM/wxMBcoHOWZPsD7F1Odh8mLfvXIrZTbtTRT5JUNtMOFtl57SAl3n5l32F
         BUN6Bn72IsiiZ03bL6WAnp2WOyz0JjgNOapv/1jehOKVFmEo3Ce4P+Rxh3BX/tEb2Tgl
         6RlQxnlEsSBgo8rIy6t+wIqCOnpQ0zM4iC0Ck=
Date: Sun, 1 Nov 2009 15:43:01 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: akpm@linux-foundation.org, m.s.tsirkin@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: fix ->stack_start in compat mode
Message-ID: <20091101124301.GA16100@x200>
References: <20091028115602.GA26295@x200>
 <1257069245.3975.6.camel@wall-e>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257069245.3975.6.camel@wall-e>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 01, 2009 at 10:54:05AM +0100, Stefani Seibold wrote:
> Am Mittwoch, den 28.10.2009, 14:56 +0300 schrieb Alexey Dobriyan:
> > Assign tsk->stack_start even when doing compat execve(2).
> > 
> > As side effect, fix segfault inside boehm-gc library.
> > http://bugzilla.kernel.org/show_bug.cgi?id=14478
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> > ---
> > 
> >  Michael, please, confirm.
> > 
> >  Stefani, I get "Stack usage: 0 kB", you may want to look at it.
> > 
> 
> Under which circumstance do you get 0 kb reported? What is your system
> (mmu/nommu, 32bit/64bit, architecture and so on).

Well, no wonder it doesn't work:

	#define KSTK_ESP(tsk)           -1 /* sorry. doesn't work for syscall. */

How does it supposed to work on live task?
