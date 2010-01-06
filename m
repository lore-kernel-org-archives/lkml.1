Return-Path: <linux-kernel-owner+w=401wt.eu-S932667Ab0AFTj2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0AFTj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:39:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932538Ab0AFTj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:39:27 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:40332 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932455Ab0AFTj1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:39:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CxHAhnrP3lj0MV4ipZHhwo60hBUsX8l3lV9kiX/r77m1RPwdPrz+JQiWn58Pfdz1ND
         OqHQrKLrh4AlJKnaNatmZBvZ0nJWdZom/yHi7i6QQTwpGoseu7ieVtCIzlPAHp9iqO3y
         a4vigWggYQAAzqLv9s9b8lH126zCdPpL6C91g=
MIME-Version: 1.0
In-Reply-To: <20100106130400.7f30ae55@torg>
References: <20100106130400.7f30ae55@torg>
Date: Wed, 6 Jan 2010 20:39:25 +0100
X-Google-Sender-Auth: c32cbfd512b10210
Message-ID: <520f0cf11001061139j2af13403qfcbf567647bdfaa8@mail.gmail.com>
Subject: Re: [RFC] [rt-tests] change to cyclictest behavior
From: John Kacur <jkacur@redhat.com>
To: Clark Williams <williams@redhat.com>
Cc: RT <linux-rt-users@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 8:04 PM, Clark Williams <williams@redhat.com> wrote:
> RT-ers,
>
> I have a problem with the way cyclictest sets up measurement threads,
> but before I went and changed things I thought I would ask if people
> cherished this particular behavior.
>
> Currently, when cyclictest is run with multiple threads (i.e. -t
> option) it distributes both the sample interval and the realtime
> priority by adding the 'distance' parameter to the interval and
> decrementing the priority by one. This means if you have a distance of
> 500us (default), a specified RT priority of 95 and start four threads,
> they will be started with the following parameters:
>
> $ cyclictest -t4 -p95
>
> Will give you:
>
> thread          priority        sample interval
> 0               95              500
> 1               94              1000
> 2               93              1500
> 3               92              2000
>
> What I'd like to do is modify this logic so that when '-a' (affinity) is
> specified, the priority and sample interval will not be altered. I
> don't think there's any point in distributing the priority's and
> sample intervals when the measurement threads are pinned to their own
> CPU.
>
> So:
>
> $ cyclictest -t4 -p95 -a
>
> Would have each thread at SCHED_FIFO 95 and a sample interval of 500us.
>
> Note that this behavior also occurs when the histogram (-h) option is
> specified).
>
> Thoughts?
>

Seems reasonable to me. Maybe it would also be nice to have a flag to
get the old behaviour back even with -a?

John
