Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220Ab0AER6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab0AER6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 12:58:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754684Ab0AER6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 12:58:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab0AER6e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 12:58:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20091226184722.GA25275@merkur.ravnborg.org>
References: <20091226184722.GA25275@merkur.ravnborg.org> <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Alexander Beregalov <a.beregalov@gmail.com>,
       arnd@arndb.de, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
Date: Tue, 05 Jan 2010 17:58:18 +0000
Message-ID: <9664.1262714298@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> +#define BUG() do {							\
> +		for (;;)						\
> +			/* endless loop*/;				\
> +		unreachable();						\
> +} while(0)

Can you not do:

	#define BUG() do {						\
			unreachable();					\
	} while(1)

instead?  If the compiler is interpreting unreachable() to really mean that
what comes after will not be reached, then the condition/loop at the end of
the block should be optimised away.

David
