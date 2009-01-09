Return-Path: <linux-kernel-owner+w=401wt.eu-S1759908AbZAIWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759908AbZAIWnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbZAIWnB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:43:01 -0500
Received: from matrixpower.ru ([195.178.208.66]:40866 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510AbZAIWnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:43:00 -0500
Date: Sat, 10 Jan 2009 01:42:58 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Willy Tarreau <w@1wt.eu>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Miller <davem@davemloft.net>,
       ben@zeus.com, jarkao2@gmail.com, mingo@elte.hu,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [PATCH] tcp: splice as many packets as possible at once
Message-ID: <20090109224258.GA10257@ioremap.net>
References: <49667534.5060501@zeus.com> <20090108.135515.85489589.davem@davemloft.net> <4966F2F4.9080901@cosmosbay.com> <49677074.5090802@cosmosbay.com> <20090109185448.GA1999@1wt.eu> <4967B8C5.10803@cosmosbay.com> <20090109212400.GA3727@1wt.eu> <20090109220737.GA4111@1wt.eu> <4967CBB9.1060403@cosmosbay.com> <20090109221744.GA4819@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090109221744.GA4819@1wt.eu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2009 at 11:17:44PM +0100, Willy Tarreau (w@1wt.eu) wrote:
> However I'm OK for the !timeo before release_sock/lock_sock. I just
> don't know if we can put the rest of the if above or not. I don't
> know what changes we're supposed to collect by doing release_sock/
> lock_sock before the if().

Not to interrupt the discussion, but for the clarification, that
release_sock/lock_sock is used to process the backlog accumulated while
socket was locked. And while dropping additional pair before the final
release is ok, but moving this itself should be thought of twice.

-- 
	Evgeniy Polyakov
