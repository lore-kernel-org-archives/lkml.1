Return-Path: <linux-kernel-owner+w=401wt.eu-S1754100Ab0AWJ32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab0AWJ32 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 04:29:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471Ab0AWJ32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 04:29:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:9018 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab0AWJ30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 04:29:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HBoPc22vcaAUVwATeMBFmY2zeezyWK2jo7KkGFUcf0NcO0xDGoQHavo5bPt+XeCBug
         s0SGWdfiTqHgh1zitMW66N8/i4V0l4nW10P8UuZiXH7m/aI6+7/jPbd+4KiUQ7j3PwO2
         ujvaOSI56/TX3VmgxxeUxxMT6InXIeZVzpKlU=
Subject: Re: [Update][PATCH] MM / PM: Force GFP_NOIO during
 suspend/hibernation and resume
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201001222219.15958.rjw@sisk.pl>
References: <201001212121.50272.rjw@sisk.pl>
	 <20100122103830.6C09.A69D9226@jp.fujitsu.com>
	 <1264155067.15930.4.camel@maxim-laptop>  <201001222219.15958.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 11:29:22 +0200
Message-ID: <1264238962.16031.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-22 at 22:19 +0100, Rafael J. Wysocki wrote: 
> On Friday 22 January 2010, Maxim Levitsky wrote:
> > On Fri, 2010-01-22 at 10:42 +0900, KOSAKI Motohiro wrote: 
> > > > > > Probably we have multiple option. but I don't think GFP_NOIO is good
> > > > > > option. It assume the system have lots non-dirty cache memory and it isn't
> > > > > > guranteed.
> > > > > 
> > > > > Basically nothing is guaranteed in this case.  However, does it actually make
> > > > > things _worse_?  
> > > > 
> > > > Hmm..
> > > > Do you mean we don't need to prevent accidental suspend failure?
> > > > Perhaps, I did misunderstand your intention. If you think your patch solve
> > > > this this issue, I still disagree. but If you think your patch mitigate
> > > > the pain of this issue, I agree it. I don't have any reason to oppose your
> > > > first patch.
> > > 
> > > One question. Have anyone tested Rafael's $subject patch? 
> > > Please post test result. if the issue disapper by the patch, we can
> > > suppose the slowness is caused by i/o layer.
> > 
> > I did.
> > 
> > As far as I could see, patch does solve the problem I described.
> > 
> > Does it affect speed of suspend? I can't say for sure. It seems to be
> > the same.
> 
> Thanks for testing.

I'll test that too, soon.
Just to note that I left my hibernate loop run overnight, and now I am
posting from my notebook after it did 590 hibernate cycles.


Offtopic, but Note that to achieve that I had to stop using global acpi
hardware lock. I tried all kinds of things, but for now it just hands
from time to time.
See http://bugzilla.kernel.org/show_bug.cgi?id=14668

Best regards,
Maxim Levitsky




