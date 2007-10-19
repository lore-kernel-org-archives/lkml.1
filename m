Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbXJSPFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbXJSPFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 11:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755930AbXJSPE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 11:04:57 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:64794 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbXJSPE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 11:04:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=Ilfu5JYPpMmRyZoBQLJbHA/ioF5pIfIyAeVSutqeddLmmzR4QsuDUMoHsDWbA2fSWJBNbE8mmjgC6pDpHzKY11hnk1iJqZKWx7RVbME2FDjGBGDJNQTc6PmpvGTT4qw8Bt4ubI/sK7+lo/GDMJmYxWyWuCfhxiWaqabTw/E6XUc=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Power button policy and mechanism
Date: Fri, 19 Oct 2007 11:04:45 -0400
User-Agent: KMail/1.9.7
Cc: Kristoffer Ericson <kristoffer.ericson@gmail.com>,
       linux-input <linux-input@atrey.karlin.mff.cuni.cz>,
       linux-main <linux-kernel@vger.kernel.org>
References: <20071016134050.f7106efe.Kristoffer.Ericson@Gmail.com> <d120d5000710160734occe82cke989baf3d1f97130@mail.gmail.com> <1192787667.5714.22.camel@localhost.localdomain>
In-Reply-To: <1192787667.5714.22.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710191104.45698.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

On Friday 19 October 2007, Richard Purdie wrote:
> On Tue, 2007-10-16 at 10:34 -0400, Dmitry Torokhov wrote:
> > On 10/16/07, Kristoffer Ericson <kristoffer.ericson@gmail.com> wrote:
> > > This is mainly an embedded issue, but I feel it's quite important. 
> > > It should apply to other devices also like for example Zaurus
> > > branches (those with keyboard and designated power button).
> 
> There was a long discussion thread about this a while back. There were a
> lot of differing views but in the end no patch to fix up power.c to do
> anything was accepted. The Zaurus was the reason I raised the issue.
> 
> It seems power.c was recently removed as it was dead code.

That's because nothing in mainline was using it.

> 
> > > So in short:
> > > 1. Does mainline policy allow static power button events inside kernel (power button == suspend/resume)?
> > >        Why/Why Not?
> > 
> > Could it be that you may want to prevent suspend from happening? Or
> > delay it until system completes some important operation? Do something
> > else, like cleanly disconnect your network connections? With actual
> > handling done in userspace it's all possible. With suspend done
> > directly in kernel it is much harder and couples input subsystem with
> > power management too tightly.
> > 
> > However if you are dead-set on doin it in kernel you coudl register an
> > input_handler in your platform PM code and it will attach to your
> > keyboard. Look for power.c module in older kernels for example.
> 
> The proposed changes to power.c were to hook it into things like APM as
> a "user" event so the power button triggered a suspend event but
> anything in userspace needing to know about (or veto) it could do so.
> 
> > > 2. Seeing as my knowledge about this area isn't the best I would 
> > > appreciate all opinions on the subject from the gurus.
> > 
> > Richard Purdie I think might have some pointers.
> 
> Currently I still patch this functionality into the Zaurus kernels
> (basically by resurrecting power.c with the patches I used to apply to
> it added in):
> 
> http://www.rpsys.net/openzaurus/patches/input_power-r9.patch
> 
> This works for 2.6.23 but doesn't seem to work in 2.6.23-git9. I've not
> looked into why yet.
> 
> In the current climate, this will never make mainline kernels so I will
> be considering other options such as adding support into something like
> OHM. As yet, I've not found the time to do that and since the above
> patch works and is relatively easy to maintain...
> 

I think power.c as it was is not a good idea. Generic code does not know
the best way of shutting down/suspending a certain box. However having an
arch- (or even board-) specific version of power.c that pligs directl
and poperly into appropriate PM mechanism makes more sense. If certain
platforms need it I don't see a reason to prevent them from doing so.

-- 
Dmitry
