Return-Path: <linux-kernel-owner+w=401wt.eu-S1754949AbZGBLPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754949AbZGBLPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 07:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbZGBLP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 07:15:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:3227 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbZGBLP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 07:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Ivb2fquqV7kpLvBqQZ44i63Or50sD6iXTmzo4NZ7h3xVbwFomxlc6MyDokB308jR9T
         VnH6GBZ3dysevd7cc7VC915huUx+mNXy1WiXqBn2Bk523FLt4YeO3hpkhy7BaHtq1okL
         Ollger+EUf9ivi9xtaAr9kws2J7ZQGrPfCBl0=
MIME-Version: 1.0
In-Reply-To: <200907011605.31154.david-b@pacbell.net>
References: <1244212590-15620-1-git-send-email-dg@emlix.com>
	 <1244637376-24666-1-git-send-email-dg@emlix.com>
	 <200907011605.31154.david-b@pacbell.net>
Date: Thu, 2 Jul 2009 14:15:29 +0300
X-Google-Sender-Auth: d913a8e17a506edf
Message-ID: <359ed6810907020415n39062238q22d1637de2c9383f@mail.gmail.com>
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

On Thu, Jul 2, 2009 at 2:05 AM, David Brownell<david-b@pacbell.net> wrote:
> On Wednesday 10 June 2009, Daniel Glöckner wrote:
>> Many gpio chips allow to generate interrupts when the value of a pin
>> changes. This patch gives usermode application the opportunity to make
>> use of this feature by calling poll(2) on the /sys/class/gpio/gpioN/value
>> sysfs file. The edge to trigger can be set in the edge file in the same
>> directory. Possible values are "none", "rising", "falling", and "both".
>
> Looks pretty clean.  Comments from anyone else?

I'd appreciate a kernel side interface to gpio_setup_irq functionality
as well; now gpio_export from kernel won't setup support for poll(2)
nor is there any possibility to do so. Having said that, it can be
done in another patch, another day, I don't want that to be holding
this patch back.

And I guess it might also be argued that anyone wanting to poll(2) can
setup edge triggering from user space when needed. Other thoughts on
that?


BR,
Jani.
