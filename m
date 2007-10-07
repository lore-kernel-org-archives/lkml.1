Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbXJGX4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbXJGX4z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 19:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbXJGX4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 19:56:48 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:60013 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbXJGX4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 19:56:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=UNeJ7+yosnRbDBNC83nElvKGQjQRxf2N3FyILFuIN8JDckoacVZ5D7XHsmnwvyZ3E4kSPhjcOxJVlhwwK8luOO4GfPMpWjQIUwpRcB7acYL7JCItwfWoRKi/fmTbepeDkaxhyQidewKek2uFaLGk/4YXyHJpKxWu0cZFsMx9Eiw=
Message-ID: <2c0942db0710071656q1e54dbe4pf04a9dbbed018f4b@mail.gmail.com>
Date: Sun, 7 Oct 2007 16:56:42 -0700
From: "Ray Lee" <ray-lk@madrabbit.org>
To: "Luciano Rocha" <strange@nsk.no-ip.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       linux-kernel@vger.kernel.org,
       "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>, dhaval@linux.vnet.ibm.com
Subject: Re: can't change euid 0 to uid != running user
In-Reply-To: <20071007164937.GA4382@bit.office.eurotux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071005142541.GA9224@bit.office.eurotux.com>
	 <2c0942db0710050828jcb161c0qc10e65f7f65af6c4@mail.gmail.com>
	 <20071007164937.GA4382@bit.office.eurotux.com>
X-Google-Sender-Auth: 9890a7c3a8413e34
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/07, Luciano Rocha <strange@nsk.no-ip.org> wrote:
> On Fri, Oct 05, 2007 at 08:28:50AM -0700, Ray Lee wrote:
> > On 10/5/07, Luciano Rocha <strange@nsk.no-ip.org> wrote:
> > > I have the following problem:
> > > $ sudo -u ie -s # or sudo su ie
> > > unable to change to runas uid: Resource temporarily unavailable
> > >
> > > Works:
> > > $ sudo su, followed by su ie
> > > [........]
> > > (Clone of Linus' tree, after rc9, with some patches from
> > > mingo/linux-2.6-sched-devel.git, and a fix for lguest (didn't link due
> > > to kasprintf)).
> >
> > Hmm, it works for me under 2.6.23-rc6, so it's either a difference
> > between our .configs or a late regression. If you could bisect the
> > problem (starting with reverting Ingo's sched devel patches and lguest
> > patches, and trying that), then that would tell us where the issue is.
> >
>
> Without the patches, i.e., a clean Linus tree (v2.6.23-rc9-41-g804b3f9),
> I can't reproduce it anymore.
>

Okay, so it's probably the issue Srivatsa identified and mentioned to
you, regarding a possible bug in the CFS-devel tree:

> This seems to be similar to the problem Ingo reported
> (http://marc.info/?l=linux-kernel&m=119125007102969). We have sent a fix
> for it subsequently (http://marc.info/?l=linux-kernel&m=119143193812026).
>
> Can you resync to Ingo's latest cfs-devel tree (which will remove the
> bad patch you have), then apply the patch at
> http://marc.info/?l=linux-kernel&m=119143193812026 and verify if the
> problem goes away?

Ray
