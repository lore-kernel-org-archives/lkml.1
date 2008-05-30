Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYE3XKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYE3XKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 19:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754105AbYE3XKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 19:10:39 -0400
Received: from web36603.mail.mud.yahoo.com ([209.191.85.20]:43424 "HELO
	web36603.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754109AbYE3XKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 19:10:38 -0400
X-YMail-OSG: tP9O2FkVM1kbYccOU1qAufdyRnGBqAc6sJHEJSER5hTuwhLVy_MB.qTqeyq6LJxuN1rFZvlU3RPilb0UGXuK9dkC49_fpeb4QQ--
X-RocketYMMF: rancidfat
Date: Fri, 30 May 2008 16:10:37 -0700 (PDT)
From: Casey Schaufler <casey@schaufler-ca.com>
Reply-To: casey@schaufler-ca.com
Subject: Re: [PATCH BUGFIX -rc4] Smack: Respect 'unlabeled' netlabel mode
To: "Ahmed S. Darwish" <darwish.07@gmail.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Paul Moore <paul.moore@hp.com>
Cc: linux-security-module@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080530233603.GA2994@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <538684.41302.qm@web36603.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- "Ahmed S. Darwish" <darwish.07@gmail.com> wrote:

> Hi all,
> 
> In case of Smack 'unlabeled' netlabel option, Smack passes a _zero_
> initialized 'secattr' to label a packet/sock. This causes an 
> [unfound domain label error]/-ENOENT by netlbl_sock_setattr().
> Above Netlabel failure leads to Smack socket hooks failure causing 
> an always-on socket() -EPERM error.
> 
> Such packets should have a netlabel domain agreed with netlabel to 
> represent unlabeled packets. Fortunately Smack net ambient label 
> packets are agreed with netlabel to be treated as unlabeled packets. 
> 
> Treat all packets coming out from a 'unlabeled' Smack system as
> coming from the smack net ambient label.

To date the behavior of a Smack system running with nltype
unlabeled has been carefully undefined. The way you're defining
it will result in a system in which only processes running with
the ambient label will be able to use sockets, unless I'm reading
the code incorrectly. This seems like "correct" behavior, but
I don't think it is what those who've tried it would expect.


Casey Schaufler
casey@schaufler-ca.com
