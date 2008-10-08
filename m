Return-Path: <linux-kernel-owner+w=401wt.eu-S1756793AbYJHW5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793AbYJHW5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 18:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJHW5X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 18:57:23 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:34250 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbYJHW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 18:57:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=vl95skQ72WbIzZF5TPrnMRg3/ZF5/m6dLJbNWKpLIwD662KG/5hjnxD+ziyRVz5YHB
         S11kz13C3r5q070xXIvICUlma9FJ9lwpQXO2qYK7dHBdsr3rs9YpZSi+9sMOjtZnrAgY
         iXH0yzvzLhy9B8p/vWOGR25a1K9OTnflHR7qo=
Message-ID: <1f1b08da0810081557u14d7b7b8p872d8454016ae8bf@mail.gmail.com>
Date: Wed, 8 Oct 2008 15:57:21 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "Rodolfo Giometti" <giometti@linux.it>
Subject: Re: [PATCH 10/10] PPS: low level IRQ timestamps recording.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Dave Jones" <davej@redhat.com>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Greg KH" <greg@kroah.com>, "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <1222933309-2524-11-git-send-email-giometti@linux.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222933309-2524-1-git-send-email-giometti@linux.it>
	 <1222933309-2524-3-git-send-email-giometti@linux.it>
	 <1222933309-2524-4-git-send-email-giometti@linux.it>
	 <1222933309-2524-5-git-send-email-giometti@linux.it>
	 <1222933309-2524-6-git-send-email-giometti@linux.it>
	 <1222933309-2524-7-git-send-email-giometti@linux.it>
	 <1222933309-2524-8-git-send-email-giometti@linux.it>
	 <1222933309-2524-9-git-send-email-giometti@linux.it>
	 <1222933309-2524-10-git-send-email-giometti@linux.it>
	 <1222933309-2524-11-git-send-email-giometti@linux.it>
X-Google-Sender-Auth: 9a9fae23c6ccc913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 2, 2008 at 12:41 AM, Rodolfo Giometti <giometti@linux.it> wrote:
> Add low level IRQ timestamps recording for x86 (32 and 64 bits)
> platforms and enable UART clients in order to use it.
>
> This improves PPS precision. :)
>
> Signed-off-by: Rodolfo Giometti <giometti@linux.it>

Hey Rodolfo,
   First of all, kudos to your persistence on this patch set, it
really has been a long time that you've been pushing this. Hopefully
it won't take much longer. :)

I've never had much experience with PPS devices, so other then knowing
a fair number of folks who are interested in using them, most of the
code is outside of my realm of knowledge, so I've not had much to
comment upon.

However, Thomas asked me to check and see how this interacted with the
timekeeping subsystem, so I took another look at the current code.
>From a quick review, I really don't see any interactions. The code
seems fairly well isolated.

One question I have is:  Do you have any plans for integrating with
the adjtimex() interface and its pps values?

My only other comment is on this last patch #10, and as you said in
your original post, its deferrable. I'd agree that dropping this patch
for now would be best, since adding a getnstimeofday() call, which may
take a few microseconds on common hardware, to every interrupt would
be a bad idea.

It seems having a special flag on the IRQ for timestamping would be
better, and then we could only enable it for PPS connected interrupts.
It may add a touch more jitter but I think it would allow for better
performance while still reducing jitter.

So yea. Unless there are objections from the serial and parallel port
maintainers, or someone who has more experience with PPS devices and
might better critique the API proposed, I see no reason for holding
this patch set back from my (limited) perspective.

thanks
-john
