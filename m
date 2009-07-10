Return-Path: <linux-kernel-owner+w=401wt.eu-S1753707AbZGJKKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707AbZGJKKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 06:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751323AbZGJKKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 06:10:15 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:64552 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbZGJKKN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:10:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=qqGbtlIUfiNVMQ4MkrdB6bExrwsgIk4xLkm7bS2uCbEOQVgfiQyFLTOsOPeZq70RJ6
         b79tUkX4wCcQPk27Skl0fKKW4UXsgC2Gb2DtSXtaaAqeMVLXvvUD1/TygD5Cqv/scqCb
         vIoQ7BmWQw4/uQM6C7RGv7SVuQwGL+eRSyHjY=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com>
References: <1247156020.27671.40.camel@debian-nb>
	 <20090710084745.GA26752@elte.hu>
	 <1247215920.32044.3.camel@penberg-laptop>
	 <20090710090351.GD14666@wotan.suse.de>
	 <1247217263.771.8.camel@penberg-laptop>
	 <20090710092921.GF14666@wotan.suse.de>
	 <1247218826.771.15.camel@penberg-laptop>
	 <alpine.DEB.2.00.0907100243010.14601@chino.kir.corp.google.com>
	 <1247219506.771.22.camel@penberg-laptop>
	 <alpine.DEB.2.00.0907100253560.14601@chino.kir.corp.google.com>
Date: Fri, 10 Jul 2009 13:10:11 +0300
X-Google-Sender-Auth: d5e23f6dac7ac18a
Message-ID: <84144f020907100310gec596cfo718631df2c7d9b46@mail.gmail.com>
Subject: Re: [RFC][PATCH] Check write to slab memory which freed already using 
	mudflap
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: David Rientjes <rientjes@google.com>
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Janboe Ye <yuan-bo.ye@motorola.com>, linux-kernel@vger.kernel.org,
       vegard.nossum@gmail.com, fche@redhat.com, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

On Fri, Jul 10, 2009 at 1:03 PM, David Rientjes<rientjes@google.com> wrote:
> It's my opinion that slab is on its way out when there's no benchmark that
> shows it is superior by any significant amount.  If that happens (and if
> its successor is slub, slqb, or a yet to be implemented allocator), we can
> probably start a discussion on what's in and what's out at that time.

Performance matters a lot, but it's certainly not the only priority
here. Look at slab, it's bootstrap code is a train-wreck which bit us
in the ass when we did the earlyslab thing and the NUMA support is
pretty horrible. The code base hasn't received much attention for the
past few years so unless someone steps up to clean it all, it's on
it's way out, like it or not.

So if you care about performance and have benchmarks that are _known_
to regress, you might want to focus your efforts on SLUB and/or SLQB
because that's where the action happens these days.

                        Pekka
