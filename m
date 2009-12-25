Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZLYAFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZLYAFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 19:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZLYAFq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 19:05:46 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:50444 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751498AbZLYAFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 19:05:46 -0500
Date: Thu, 24 Dec 2009 18:05:42 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
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
       =?iso-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: A basic question about the security_* hooks
Message-ID: <20091225000542.GA22311@us.ibm.com>
References: <20091224022902.GA24234@heat>
 <4B32F304.4040609@schaufler-ca.com>
 <m1hbrgildc.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbrgildc.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> Casey Schaufler <casey@schaufler-ca.com> writes:
> 
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
> 
> With my maintainer of a general purpose kernel hat on I would love to
> be able to build in all of the security modules and select at boot
> time which ones were enabled.

You're supposed to be able to do that now - use the "security=smack"
or whatever boot option (see security/security.c:choose_lsm() ).

-serge
