Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZLYBJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZLYBJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 20:09:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753287AbZLYBJ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 20:09:27 -0500
Received: from lists.laptop.org ([18.85.2.145]:51157 "EHLO mail.laptop.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752888AbZLYBJ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 20:09:26 -0500
Date: Thu, 24 Dec 2009 20:11:29 -0500
From: Michael Stone <michael@laptop.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, David Lang <david@lang.hm>,
       Oliver Hartkopp <socketcan@hartkopp.net>,
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
       Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       Samir Bellabes <sam@synack.fr>,
       Casey Schaufler <casey@schaufler-ca.com>,
       Michael Stone <michael@laptop.org>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091225011128.GA5213@heat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20091225001422.GB22311@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge Hallyn writes:
> Michael Stone writes:
>> In particular, what would be worse about a kernel in which each security hook
>> contained nothing but conditionally-compiled function calls to the appropriate
>> "real" implementation functions with early-exit jumps on non-zero return codes?
>
> The problem is that composing any two security policies can quickly have
> subtle, unforeseen, but dangerous effects. 

First, thanks very much for your helpful explanations and pragmatic advice.

Second, two thoughts and a question:

   1. I think you're probably correct when we're discussing security policies
      chosen uniformly at random from the space of all possible such policies.
      However, I believe that the cost-benefit ratio favors composition quite
      strongly when we're discussing real security policies which where designed
      with composition in mind, as is the case with my work.

   2. The problem you cite is an inherent property of software assurance which
      is indepedent of software assurance of information-security-specific
      properties. Thus, while you are correct that composition sometimes makes
      it harder to assure a system due to the increased number of "moving
      parts" that have to fit together perfectly, it also frequently makes the
      assurance problem more tractable by reducing the cost to assure the
      individual pieces which are being composed.

   3. Have you any specific examples of problems that have been clearly averted
      by the current arrangement?

> So with your module, I'd recommend following the route of the capabilities
> LSM. You can provide an optional stand-alone LSM which only hooks your
> functions. Then smack, for instance, can call the functions in your LSM
> from within its own hooks, or it can simply explicitly assign its hooks to
> your functions in smack_ops.  Selinux can do the same thing, although I
> suspect they would more likely implement their own functions for your newly
> hooked sites.

Doesn't it seem a bit strange to you to be recommending that everyone else
using the five security hooks I want to use modify their code *in detail* to
support my functionality given that my functionality is explicitly intended not
to require any such work on their part?

This seems frankly silly to me, not to mention expensive and error-prone.

Instead, perhaps we'd be better off with something like a declarative
compile-time whitelist or blacklist for compositions?

Regards,

Michael
