Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbYCRFvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbYCRFvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 01:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751081AbYCRFvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 01:51:39 -0400
Received: from 1wt.eu ([62.212.114.60]:2526 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbYCRFvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 01:51:38 -0400
Date: Tue, 18 Mar 2008 06:48:19 +0100
From: Willy Tarreau <w@1wt.eu>
To: Nebojsa Miljanovic <neb@alcatel-lucent.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       "Kittlitz, Edward (Ned)" <nkittlitz@alcatel-lucent.com>,
       asweeney@alcatel-lucent.com,
       "Polhemus, William (Bart)" <bpolhemus@alcatel-lucent.com>
Subject: Re: SO_REUSEADDR not allowing server and client to use same port
Message-ID: <20080318054819.GE13012@1wt.eu>
References: <47C6FA2A.5030302@alcatel-lucent.com> <20080228201926.558c4e7c@core> <47D97DF7.8000702@alcatel-lucent.com> <20080315133426.1f48c99c@the-village.bc.nu> <47DE9FB0.5030801@alcatel-lucent.com> <20080317173021.28e6fd97@core> <47DEB5B9.4030905@alcatel-lucent.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DEB5B9.4030905@alcatel-lucent.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 01:17:29PM -0500, Nebojsa Miljanovic wrote:
> OK. I see. So, it would have to be some malicious application running together
> with the server (i.e. on the same CPU). I do see now why you said it would be
> very very hard to make this happen.
> 
> Still, it would be nice to introduce SO_REUSEPORT socket options so secure
> servers (who happen to be clients as well) can re-use ports when necessary.
> 
> Another option would be to check if port re-use is happening inside same
> application and allow it. That may make half of the folks happy, so I am not
> sure if I like it as much as I like SO_REUSEPORT option.

It is most often useful for hot-restart without interrupting service.
As an example, when I update a config in haproxy, I restart a new instance
which does everything and binds to the ports, and then signals the old one
it may go. That way, there is a complete continuity of service. This is
possible by default on *BSD, and with a (very) little patch on linux.

And I agree with Alan about the security implications. If a service binds
itself with SO_REUSEPORT, it definitely says "I agree to share my connection".
So this is not to be used by default in any random application. But for
servers, it's really useful.

Willy

