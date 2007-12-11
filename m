Return-Path: <linux-kernel-owner+w=401wt.eu-S1755364AbXLKSpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364AbXLKSpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 13:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160AbXLKSpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 13:45:09 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:55729 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbXLKSpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 13:45:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=jMJxiQiRnku9kVTTwwkPEII6suvyaOLr6l9qSKIkK18q2m7sz1fIi3RBpjQO/u4DzS8If2yBU7n10eSo48m7yph7STJlm9WisrrhMcm7DT5NDptRTvXk/v2uiNAXgimrPi25dKxMlaVG9Mip41QhFMvCTFfQuN21vcofu+KbBtA=
Message-ID: <86802c440712111045j1384930ak77f06f4c7336aae7@mail.gmail.com>
Date: Tue, 11 Dec 2007 10:45:01 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Neil Horman" <nhorman@tuxdriver.com>
Subject: Re: [PATCH] kexec: force x86_64 arches to boot kdump kernels on boot cpu
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Ben Woodard" <woodard@redhat.com>, "Neil Horman" <nhorman@redhat.com>,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       "Andi Kleen" <ak@suse.de>, hbabu@us.ibm.com,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <20071211182951.GC10999@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440712070050s3c5017a4w8e747a7035d10d3a@mail.gmail.com>
	 <20071207142144.GA10389@hmsendeavour.rdu.redhat.com>
	 <20071207175832.GA18485@hmsreliant.think-freely.org>
	 <m1k5nm2g3w.fsf@ebiederm.dsl.xmission.com>
	 <20071211034349.GA3635@localhost.localdomain>
	 <m1ejdt25x0.fsf@ebiederm.dsl.xmission.com>
	 <20071211143910.GA10999@hmsreliant.think-freely.org>
	 <m1ve75z1v3.fsf@ebiederm.dsl.xmission.com>
	 <86802c440712111000l39291faaka797bc4ee22f798a@mail.gmail.com>
	 <20071211182951.GC10999@hmsreliant.think-freely.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 11, 2007 10:29 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Tue, Dec 11, 2007 at 10:00:00AM -0800, Yinghai Lu wrote:
> > On Dec 11, 2007 7:29 AM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >
> > > I'm actually inclined to remove the return magic and just do something
> > > like:
> > >         static fix_applied;
> > >         if (fix_applied++)
> > >                 return;
> > > In those functions that should be called only once.
> >
> > it seems we need to have two tables. one for northbridge (sweep all
> > the NB_K8) and another for SB ( like Nvidia, ati..., one touch and
> > leave)
> >
> > YH
> >
> I like Erics idea better I think.  My origional patch had two tables, and it
> seems that it made the early quirk detection logic that much more convoluted.
> This way each quirk can determine if it needs to be applied to more than one pci
> device.
>

nvidia or ati chip will come first, and then amd NB ( K8). So you need
to make sure "fix_applied return" is not going to skip your fix to
K8_NB.

YH
