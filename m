Return-Path: <linux-kernel-owner+w=401wt.eu-S1754619AbZLXMxn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619AbZLXMxn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 07:53:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLXMxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 07:53:41 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:56646 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbZLXMxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 07:53:40 -0500
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Michael Stone <michael@laptop.org>, linux-kernel@vger.kernel.org,
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
       =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Subject: Re: A basic question about the security_* hooks
References: <20091224022902.GA24234@heat> <4B32F304.4040609@schaufler-ca.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 24 Dec 2009 04:53:35 -0800
In-Reply-To: <4B32F304.4040609@schaufler-ca.com> (Casey Schaufler's message of "Wed\, 23 Dec 2009 20\:50\:12 -0800")
Message-ID: <m1hbrgildc.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> writes:

> I'm behind you 100%. Use the LSM. Your module is exactly why we have
> the blessed thing. Once we get a collection of otherwise unrelated
> LSMs the need for a stacker will be sufficiently evident that we'll
> be able to get one done properly.

My immediate impression is that the big limitation today is the
sharing of the void * security data members of strucutres.

Otherwise multiple security modules could be as simple as.
list_for_each(mod)
        if (mod->op(...) != 0)
		return -EPERM.

It isn't hard to multiplex a single data field into several with a
nice little abstraction.

With my maintainer of a general purpose kernel hat on I would love to
be able to build in all of the security modules and select at boot
time which ones were enabled.

Eric

