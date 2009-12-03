Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbZLCTip@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbZLCTip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 14:38:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753511AbZLCTin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 14:38:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1281 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838AbZLCTin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 14:38:43 -0500
Subject: Re: [Patch] selinux: remove an unreachable line
From: Joe Perches <joe@perches.com>
To: Cong Wang <amwang@redhat.com>
Cc: Dan Carpenter <error27@gmail.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@parisplace.org>,
       linux-security-module@vger.kernel.org, akpm@linux-foundation.org,
       James Morris <jmorris@namei.org>
In-Reply-To: <4B17793F.7050708@redhat.com>
References: <20091201074422.4410.60874.sendpatchset@localhost.localdomain>
	 <1259653523.21388.7.camel@Joe-Laptop.home> <4B14D468.2090502@redhat.com>
	 <20091202123558.GC5224@bicker>  <4B17793F.7050708@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 11:38:47 -0800
Message-ID: <1259869127.22783.70.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 16:39 +0800, Cong Wang wrote:
> Dan Carpenter wrote:
> > On Tue, Dec 01, 2009 at 04:31:36PM +0800, Cong Wang wrote:
> >> Joe Perches wrote:
> >>> On Tue, 2009-12-01 at 02:41 -0500, Amerigo Wang wrote:
> >>>> This line is unreachable, remove it.
> >>> []
> >>>> diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
> >>>> index b5407f1..a2f1034 100644
> >>>> --- a/security/selinux/ss/mls.c
> >>>> +++ b/security/selinux/ss/mls.c
> >>>> @@ -544,7 +544,6 @@ int mls_compute_sid(struct context *scontext,
> >>>>  	default:
> >>>>  		return -EINVAL;
> >>>>  	}
> >>>> -	return -EINVAL;
> >>>>  }
> >>> I think it's better to remove the default case.
> >>>
> >> This is totally a personal taste, I think.
> >> Either is OK. James, any comments?
> > 
> > I think the last unreachable return might also stop certain
> > versions of gcc complaining about control reaching the end of
> > a non void function.
> 
> Hmm, aren't those version of gcc buggy? Here we have return values
> in all cases of 'switch', it shouldn't complain...

Various versions of gcc do complain.

It's also a bit counter-expectation to
the reader to find no return at the end
of a non-void function.

As a reader, you then have to scan the
cases to find the default: case which
isn't necessarily at the end.

If it is a simple
	default:
		return foo;

I think it less jarring to omit
default from the switch statement
and use
	return foo;
}

at the function exit.

