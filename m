Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347Ab0ADCM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab0ADCM0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 21:12:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751784Ab0ADCMZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 21:12:25 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:10605 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658Ab0ADCMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 21:12:24 -0500
From: Paul Moore <paul.moore@hp.com>
Organization: Hewlett-Packard
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: A basic question about the security_* hooks
Date: Sun, 3 Jan 2010 21:12:17 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31-gentoo-r2; KDE/4.3.4; i686; ; )
Cc: Casey Schaufler <casey@schaufler-ca.com>,
       Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       David Lang <david@lang.hm>, Oliver Hartkopp <socketcan@hartkopp.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
       Bryan Donlan <bdonlan@gmail.com>, Evgeniy Polyakov <zbr@ioremap.net>,
       "C. Scott Ananian" <cscott@cscott.net>,
       James Morris <jmorris@namei.org>, Bernie Innocenti <bernie@codewiz.org>,
       Mark Seaborn <mrs@mythic-beasts.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       =?iso-8859-1?q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
References: <20091224022902.GA24234@heat> <4B32F304.4040609@schaufler-ca.com> <m1hbrgildc.fsf@fess.ebiederm.org>
In-Reply-To: <m1hbrgildc.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001032112.17975.paul.moore@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 December 2009 07:53:35 am Eric W. Biederman wrote:
> Casey Schaufler <casey@schaufler-ca.com> writes:
> > I'm behind you 100%. Use the LSM. Your module is exactly why we have
> > the blessed thing. Once we get a collection of otherwise unrelated
> > LSMs the need for a stacker will be sufficiently evident that we'll
> > be able to get one done properly.
> 
> My immediate impression is that the big limitation today is the
> sharing of the void * security data members of strucutres.
> 
> Otherwise multiple security modules could be as simple as.
> list_for_each(mod)
>         if (mod->op(...) != 0)
> 		return -EPERM.
> 
> It isn't hard to multiplex a single data field into several with a
> nice little abstraction.

Just another quick point that I didn't see covered yet in this thread ... 
while many of the kernel entities have void pointers to track the security 
blobs, there are several places where a single u32/int or character string is 
used to represent the security label of an entity (look at the per-packet 
labeling for an example).  While it would be relatively easy to multiple 
multiple security blobs on top of a void pointer, multiplexing multiple 
security labels/tokens on top of a string/int is a little more difficult.

-- 
paul moore
linux @ hp
