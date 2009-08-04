Return-Path: <linux-kernel-owner+w=401wt.eu-S932743AbZHDK2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932743AbZHDK2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 06:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbZHDK2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 06:28:22 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:52883 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694AbZHDK2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 06:28:21 -0400
From: "Sherif F. Fahmy" <fahmy@vt.edu>
To: "'Casey Dahlin'" <cdahlin@redhat.com>
Cc: <linux-kernel@vger.kernel.org>
References: <1249312084.5762.17.camel@sherif-laptop> <4A774858.6080106@redhat.com>
In-Reply-To: <4A774858.6080106@redhat.com>
Subject: RE: scheduling co-processors
Date: Tue, 4 Aug 2009 13:28:00 +0300
Message-ID: <000301ca14ee$401f8560$c05e9020$@edu>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AcoUd9rrVmP+XMexRxqFgj/EwdFB0AAdkVnQ
Content-Language: en-us
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu fahmy@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020201.4A780D35.0050,ss=1,fgs=0,
	ip=41.196.91.126,
	so=2009-06-02 18:41:42,
	dmn=2009-06-06 00:02:10,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Casey Dahlin
> Sent: Monday, August 03, 2009 11:28 PM
> To: Sherif Fadel
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: scheduling co-processors
> 
> On 08/03/2009 11:08 AM, Sherif Fadel wrote:
> > Hi,
> >
> > I have a dual-core system on which I would like to treat one
> processor
> > as a scheduling co-processor. I have already implemented some custom
> > scheduling policies and tested them with SMP disabled, I would not
> like
> > to see if it is possible to have the scheduling algorithm running on
> one
> > core and the scheduled tasks running on another.
> >
> > I do not know if I can somehow use cpus_allowed to restrict the
> kernel
> > to one core and the running tasks to another. Is this possible? If
> so,
> > could you please inform me how one would go about this?
> >
> > In case you are wondering why I would need this, I am writing a bunch
> of
> > high-overhead distributed scheduling algorithms and I want to
> mitigate
> > their overhead in this way.
> >
> > Thanks.
> >
> 
> The design I would have for this would be to have a kthread that does
> whatever busy work your scheduler has as a separate process. You could
> then replace the existing scheduler with a sort of "schedulerlet" that
> would simply schedule according to directions queued up for it by the
> kthread task. From there cpu affinity should get you the "dedicated
> scheduler processor" you want.
> 
> I can't even begin to envision the scheduling algorithm that would be
> able to operate this way, but I have to assume that if it makes sense
> for your scheduler to run on another CPU then it must be able to fit
> into this pattern.

Thanks for the info. I think that this will do perfectly.

> 
> --CJD
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

