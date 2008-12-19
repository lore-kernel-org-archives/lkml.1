Return-Path: <linux-kernel-owner+w=401wt.eu-S1753880AbYLSNlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbYLSNlS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 08:41:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbYLSNlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 08:41:05 -0500
Received: from wf-out-1314.google.com ([209.85.200.170]:64543 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYLSNlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 08:41:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MVAjPogo8sHvvLtiBTk6mNKARXXzPIMBr8MwLXRva+XSUXUFNLRjd7uTlE3DOktwTD
         6e7Dn8Qit70rihj95pjEHqAgj6Yyq5wW9toBZtfMXqVpgf+WlHkltT1hxw+0g9zdaS41
         fNas+YitafCbRfp5lZQZj1jtDSoiLpGfxQBF8=
Message-ID: <aec7e5c30812190541y2b6a8723ob17e3214b2109d56@mail.gmail.com>
Date: Fri, 19 Dec 2008 22:41:01 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Wolfram Sang" <w.sang@pengutronix.de>
Subject: Re: [RESEND][PATCH] uio: Add of_platform_driver to uio_pdrv_genirq
Cc: "Paul Mundt" <lethal@linux-sh.org>, hjk@linutronix.de, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
In-Reply-To: <20081216124156.GD3275@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de>
	 <20081216122524.GA29546@linux-sh.org>
	 <20081216124156.GD3275@pengutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 9:41 PM, Wolfram Sang <w.sang@pengutronix.de> wrote:
>
>> It is pretty poor form to not even bother to Cc the only author of the
>> code you are modifying, and have no Signed-off-by or Acked-by to even
>> suggest that it was ever even looked at. This isn't something that ought
>> to have to be pointed out, either.
>
> Oops, yes, forgot this in the resend, I am sorry. I did CC Magnus in the
> first round, though, and he replied to me that he liked adding OF and
> just waited for Hans' reply first.

Right, that's exactly what happened. Last time when the platform
drivers got merged was very very very intense so I expected a similar
situation. Please excuse the hands-off handling.

The result of our discussions last time was basically that we should
have two reusable uio platform drivers; the regular uio_pdrv and
uio_pdrv_genirq. The good thing with this is that we clearly show the
difference between the two drivers, most people should just use the
regular uio_pdrv driver and crazy people with unique interrupt sources
should use the genirq version.

The downside with the two drivers is the duplicated code, but I guess
that's ok for now.

>> In addition to the stuff pointed out by Greg, I don't see what you
>> actually gain by hacking the OF crap in to this driver. You would be
>> better off layering the OF driver on top of this, rather than trying to
>> make them live together in the same file.

I totally agree.

> See my reply just posted. I found two ways to go, and from reading
> discussions on the lists, finally decided for this way. May have been
> the wrong path, but nothing that could not be changed.

In my mind, the best way forward is to write a new uio driver that
interfaces to open firmware. After that we can break out things like
resource handling and maybe generic interrupt code. Please CC me and
I'll help out.

Cheers,

/ magnus
