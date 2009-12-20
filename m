Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbZLTK3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbZLTK3K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:29:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753003AbZLTK3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:29:09 -0500
Received: from 1wt.eu ([62.212.114.60]:52824 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752990AbZLTK3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:29:07 -0500
Date: Sun, 20 Dec 2009 11:28:57 +0100
From: Willy Tarreau <w@1wt.eu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Michal Marek <mmarek@suse.cz>, Michael Guntsche <mike@it-loops.com>,
       Oliver Hartkopp <oliver@hartkopp.net>,
       linux-kernel <linux-kernel@vger.kernel.org>, mjt@tls.msk.ru
Subject: Re: [PATCH] kbuild: correct size calculation of bzImgae / fix x86 boot
Message-ID: <20091220102857.GG32739@1wt.eu>
References: <20091219233457.GA4288@trillian.comsick.at> <20091220084656.GA485@merkur.ravnborg.org> <20091220091138.GA1793@trillian.comsick.at> <20091220100344.GA6614@merkur.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091220100344.GA6614@merkur.ravnborg.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 20, 2009 at 11:03:44AM +0100, Sam Ravnborg wrote:
> We use ... printf \x ... when calculating the size of the
> compressed kernel.
> Unfortunately dash built-in printf does not support this notation
> resulting in a non-bootable kernel.
> 
> Fix this by always using the external version of printf.

Do we really want to workaround shells bugs ? I mean, either
the shell correctly implements the printf function or it does
not at all so that the correct printf is found in the path.
"man printf" clearly states that \x is supported, so what
should be fixed is the shell's implementation of printf.

The more absolute paths we specify, the less portable the
build system. And if linking /bin/sh to whatever shell works
but linking it to dash breaks, it's a shell bug.

Willy

