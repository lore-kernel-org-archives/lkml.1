Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbZLaRwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbZLaRwu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 12:52:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752804AbZLaRwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 12:52:47 -0500
Received: from msux-gh1-uea02.nsa.gov ([63.239.67.2]:54996 "EHLO
	msux-gh1-uea02.nsa.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbZLaRwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 12:52:46 -0500
Subject: Re: A basic question about the security_* hooks
From: "David P. Quigley" <dpquigl@tycho.nsa.gov>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Casey Schaufler <casey@schaufler-ca.com>,
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
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
In-Reply-To: <20091225000542.GA22311@us.ibm.com>
References: <20091224022902.GA24234@heat>
	 <4B32F304.4040609@schaufler-ca.com> <m1hbrgildc.fsf@fess.ebiederm.org>
	 <20091225000542.GA22311@us.ibm.com>
Content-Type: text/plain
Organization: National Security Agency
Date: Thu, 31 Dec 2009 12:50:47 -0500
Message-Id: <1262281847.22369.0.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-24 at 18:05 -0600, Serge E. Hallyn wrote:
> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > Casey Schaufler <casey@schaufler-ca.com> writes:
> > 
> > > I'm behind you 100%. Use the LSM. Your module is exactly why we have
> > > the blessed thing. Once we get a collection of otherwise unrelated
> > > LSMs the need for a stacker will be sufficiently evident that we'll
> > > be able to get one done properly.
> > 
> > My immediate impression is that the big limitation today is the
> > sharing of the void * security data members of strucutres.
> > 
> > Otherwise multiple security modules could be as simple as.
> > list_for_each(mod)
> >         if (mod->op(...) != 0)
> > 		return -EPERM.
> > 
> > It isn't hard to multiplex a single data field into several with a
> > nice little abstraction.
> > 
> > With my maintainer of a general purpose kernel hat on I would love to
> > be able to build in all of the security modules and select at boot
> > time which ones were enabled.
> 
> You're supposed to be able to do that now - use the "security=smack"
> or whatever boot option (see security/security.c:choose_lsm() ).
> 
> -serge
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


Ubuntu and SuSe currently do this and it is what allows them to ship a
kernel with both AppArmor and SELinux support built in.

Dave

