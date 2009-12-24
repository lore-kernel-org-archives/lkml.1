Return-Path: <linux-kernel-owner+w=401wt.eu-S1752112AbZLXC1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112AbZLXC1B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 21:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751478AbZLXC1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 21:27:00 -0500
Received: from lists.laptop.org ([18.85.2.145]:48026 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751108AbZLXC07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 21:26:59 -0500
Date: Wed, 23 Dec 2009 21:29:02 -0500
From: Michael Stone <michael@laptop.org>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Michael Stone <michael@laptop.org>
Subject: A basic question about the security_* hooks
Message-ID: <20091224022902.GA24234@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear kernel folks,

There are a variety of places where I'd like to be able to get the kernel to
return EPERM more often [1]. Many of these places already have security hooks.

Unfortunately, I don't feel that I can make effective use of these hooks
because they seem to be "occupied" by the large mandatory access control
frameworks.

I'm hoping that you can tell me why this state of affairs persists.

More specifically, now that LSMs are statically linked, why is it good for the
security hooks to call into a single monolithic "security_ops" struct instead
of cheaper and simpler alternatives?

In particular, what would be worse about a kernel in which each security hook
contained nothing but conditionally-compiled function calls to the appropriate
"real" implementation functions with early-exit jumps on non-zero return codes?

Thanks,

Michael

[1]: Two examples include my recent network-privileges patches and Eric
Biederman's suggestions on how to make unprivileged unshare(CLONE_NEWNET) safe.
I have little doubt that I'd think of more if I thought that the security hooks
were accessible to me.
