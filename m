Return-Path: <linux-kernel-owner+w=401wt.eu-S1761591AbXGDOM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761591AbXGDOM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:12:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760030AbXGDOMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:12:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:56598 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905AbXGDOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=oY4m7yicvNaIHmiwC3jQbqCXfi2igX3s/09pRV8aEJOhHKMT4Yrp/wkTmRKoQk3SIzHI1SI4N/rQoGPCbxV2FPUt6tgu3V13P6+8XHK98ZXQAirY751fQpKXL+xZd/4YyMbgDlqUMalBjy8lDgjfjcUAlFtnGorYs05eonY0JvE=
Message-ID: <d120d5000707040712g76c4835bif2e226fe4710351f@mail.gmail.com>
Date: Wed, 4 Jul 2007 10:12:48 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Paul Mackerras" <paulus@samba.org>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Matthew Garrett" <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <18059.34264.421573.246262@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070703211227.GA28758@srcf.ucam.org>
	 <200707041242.59552.rjw@sisk.pl>
	 <18059.32111.58643.97174@cargo.ozlabs.ibm.com>
	 <200707041325.55779.rjw@sisk.pl>
	 <18059.34264.421573.246262@cargo.ozlabs.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/4/07, Paul Mackerras <paulus@samba.org> wrote:
> Rafael J. Wysocki writes:
>
> > They are mostly related to kernel threads, that we've already agreed no to
> > freeze (except for the ones that want that, but they will be responsible for
> > getting everything right).  The initial patches for that are in -mm and more
> > will come.
>
> Serious question: which kernel threads would actually want to be
> frozen?
>
> Threads that do no I/O at all don't care about suspend/resume and
> don't need to be frozen in any case.  Threads that issue I/O requests
> in order to service incoming I/O requests can't be frozen because of
> the possibility of deadlock.  Which leaves threads that do I/O just
> for the fun of it. :)
>
> What am I missing?
>

I like kseriod and kgameportd to be frozen. If fast resume of serio
port fails we kick the task of full resume to kseriod. But when we
hibernate and all the devices are resumed again so snapshot can be
written I don't care if touchpad failed to resume - it can be dealt
with later, when system is actually resumes. So I like that by
freezing I do not delay hibernation and all requests get simply
discarded as they are not in the image. This mostly affects
hibernation though.

Having these threads frozen also guarantees that serio/gameport device
tree is stable during susped/resume and I can process outstanding
requests later, when system is fully up.

-- 
Dmitry
