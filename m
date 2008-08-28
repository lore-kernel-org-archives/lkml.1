Return-Path: <linux-kernel-owner+w=401wt.eu-S1754829AbYH1OSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbYH1OSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:18:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbYH1OSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:18:40 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2729 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752519AbYH1OSj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:18:39 -0400
Date: Thu, 28 Aug 2008 16:18:27 +0200
From: Pavel Machek <pavel@suse.cz>
To: Markku Savela <msa@moth.iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Frustrated with capabilities..
Message-ID: <20080828141826.GA6797@ucw.cz>
References: <87hc96by8x.fsf@burp.tkv.asdf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hc96by8x.fsf@burp.tkv.asdf.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-08-27 12:31:10, Markku Savela wrote:
> I just want to run an exectable with limited capabilities and assumed
> the following approach would work fine:
> 
>  1) fork process
>  2) in child
> 
>     2.1 set current capabilities (eip) using cap_set_proc
>     2.2 execve the executable.
> 
> But it frigging does not work! Just before the execve, the result of
> cap_to_text is
> 
>     = cap_net_bind_service+eip
> 
> but, in the execve executable, the result is suddenly
> 
>     = cap_net_bind_service+i
> 
> Why does the execve clear the effective and permitted capabities,
> against my clear instructions? (I also have the prctl KEEP_CAPS set,
> though in this case it should be irrelevant).
> 
> - The kernel is from ubuntu distro, 2.6.24.
> 
> - the executable *does* *not* have any setuid/setgid bits
> 
> - the upcoming file capabities will not be any help, because I will
>   need to start the same executable with different capabilities
>   depending on context.

Yes, you need upcoming filesystem capabilities.  Binary may not
inherit capabilities unless filesystem flags permit that.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
