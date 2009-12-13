Return-Path: <linux-kernel-owner+w=401wt.eu-S1751135AbZLMFHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751135AbZLMFHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 00:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750782AbZLMFHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 00:07:09 -0500
Received: from lists.laptop.org ([18.85.2.145]:39679 "HELO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750780AbZLMFHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 00:07:08 -0500
Date: Sun, 13 Dec 2009 00:09:00 -0500
From: Michael Stone <michael@laptop.org>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-security-module@vger.kernel.org
Cc: Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>,
       =?iso-8859-1?Q?R=E9mi?= Denis-Courmont <rdenis@simphalempin.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Michael Stone <michael@laptop.org>
Subject: setrlimit(RLIMIT_NETWORK) vs. prctl(???)
Message-ID: <20091213050900.GC4369@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091213034418.GA4416@heat>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

A colleague just asked me an excellent question about my approach which I'd
like to share with you. Paraphrasing, he wrote:

> rlimits seem very heavy for a simple inherited boolean flag. Also, creating
> a new one will require modifying a lot of delicate userland software.
> Wouldn't some new prctl() flags be a better choice?

Here's my response:

> You're absolutely right that choosing to expose this functionality as an
> rlimit (as opposed to as a new syscall or as a flag to an old syscall like
> prctl()) is a decision with complex consequences.
> 
> I picked rlimits for this patch (after trying the "new syscall" approach
> privately) because doing so provides exactly the interface, semantics, and
> userland integration that I want:
>
> interface: "unprivileged", "temporarily drop", "permanently drop", "get
> current state", "persist current state across exec()", and some room for
> future expansion of semantics by definining new state values between 0 and
> RLIMIT_INFINITY.
> 
> integration: lots of sandboxing code already contains logic to drop rlimits
> when starting up an isolated process. Furthermore, I think it would be really
> great to be able to limit networking from the shell via ulimit and on a
> per-user basis via /etc/security/limits.conf.
> 
> That being said, I'm not wedded to the decision. Could you give me some more
> specific examples of the kinds of changes in low-level userspace code that
> you're worried about?

Regards,

Michael
