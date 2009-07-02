Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZGBVhc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZGBVhc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 17:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755078AbZGBVhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 17:37:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:37479 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbZGBVhY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 17:37:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Hk6WiRRSLhJ6pVE5dlpcwHMQ1lTS7oWYvxBedUbFmom0cgXGpkf1URf7S3HERMh3Xr
         tHHVwAvlnckaTWT76WEh31PSWWgGSthNg6OhSDzSYfuki6SIil+68C2U4+cejlrvkd22
         lzhz3Xkk6ECu38jtXsTJNCmY6zw6FS9RLYA+Q=
MIME-Version: 1.0
In-Reply-To: <200907021157.33250.david-b@pacbell.net>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
	 <200907011605.31154.david-b@pacbell.net>
	 <359ed6810907020415n39062238q22d1637de2c9383f@mail.gmail.com>
	 <200907021157.33250.david-b@pacbell.net>
Date: Fri, 3 Jul 2009 00:37:26 +0300
X-Google-Sender-Auth: 95f31753bd6a1d58
Message-ID: <359ed6810907021437m4417d4bfhc3d49b19387dbf96@mail.gmail.com>
Subject: Re: [PATCH v2] gpiolib: allow poll(2) on gpio value
From: Jani Nikula <ext-jani.1.nikula@nokia.com>
To: David Brownell <david-b@pacbell.net>
Cc: =?UTF-8?Q?Daniel_Gl=C3=B6ckner?= <dg@emlix.com>,
       Ben Nizette <bn@niasdigital.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 21:57, David Brownell<david-b@pacbell.net> wrote:
> On Thursday 02 July 2009, Jani Nikula wrote:
>> > Looks pretty clean.  Comments from anyone else?
>>
>> I'd appreciate a kernel side interface to gpio_setup_irq functionality
>> as well; now gpio_export from kernel won't setup support for poll(2)
>> nor is there any possibility to do so.
>
> I don't understand what you mean by this... there's no
> file descriptor open at that time, so there's no poll()
> that could be done.

I'm trying to say that if you call gpio_export() to create a sysfs
node, a subsequent poll() in user space won't work because there is no
irq set up, and sysfs_notify_dirent() won't be called. The patch
doesn't provide an interface for setting that up from kernel after
gpio_export() call - it's only possible to set up edge triggering and
sysfs notify by writing to the "edge" node from user space. That may
well be deemed sufficient, at least for now, and can be fixed later if
need be.


BR,
Jani.
