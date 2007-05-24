Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbXEXRMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbXEXRMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXEXRMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:12:36 -0400
Received: from an-out-0708.google.com ([209.85.132.245]:51514 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXEXRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:12:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MLmV3wSzWV3TWByCYJJt5Axx3c1Pf/0Cj7wstHnwx1si1oUCfiPmlZyu9S7o4jiJBsG75+SqWjCLTivz1hiOxKyLb+1+NmMI8YCAo7QTbTowhqMUS1jtNendnrBzx/rrJ03f1sq6MO2WaUbyKXJN5rDn7yM6Kk+QIudxkVPt1Ew=
Message-ID: <a781481a0705241012j513957d8vbc993cb395c31158@mail.gmail.com>
Date: Thu, 24 May 2007 22:42:27 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Krzysztof Halasa" <khc@pm.waw.pl>
Subject: Re: any value to "NORET_TYPE" macro?
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, "Adrian Bunk" <bunk@stusta.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m33b1mz7sz.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0705220904320.13623@localhost.localdomain>
	 <Pine.LNX.4.64.0705221002350.14457@localhost.localdomain>
	 <20070522161951.GC2098@stusta.de> <m3ejl8k6e3.fsf@maximus.localdomain>
	 <Pine.LNX.4.64.0705221616270.18792@localhost.localdomain>
	 <m37ir0iodl.fsf@maximus.localdomain>
	 <a781481a0705230137v4c8ba82fx263212a2958b55b9@mail.gmail.com>
	 <Pine.LNX.4.64.0705230908180.4309@localhost.localdomain>
	 <a781481a0705230646x9a0255ak4254d05ba5442cad@mail.gmail.com>
	 <m33b1mz7sz.fsf@maximus.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/24/07, Krzysztof Halasa <khc@pm.waw.pl> wrote:
> "Satyam Sharma" <satyam.sharma@gmail.com> writes:
>
> > Actually there's another thing :-) The __attribute__((xxx)) must go with the
> > function _declarations_ (and not the implementations/definitions). I noticed
> > after my previous mail that most of the double annotations are actually in
> > the case of the _declarations_ of these non-returning functions, whereas
> > most of the single-occurrences of NORET_TYPE were in the function
> > definitions, which means your patch that simply got rid of NORET_TYPE
> > actually ended up doing exactly the right thing that we wanted :-)
>
> Only half of it. Half of right thing is (here) a bad thing.
>
> NORET_TYPE does not do any harm.
> Removing it removes pointers to attrib((noreturn)) candidates.
> Simple.

NORET_TYPE didn't do any harm because it expanded to /**/. But yes,
removing it does remove the annotations / markers for ATTRIB_NORET
candidates, as I first mentioned to Rday.

But later on going through the code, I noticed that:

1. Most of the combined occurrences of NORET_TYPE along with
ATTRIB_NORET were in function _declarations_. So here, what
we want is to simply remove the NORET_TYPE, and *not* replace
it with ATTRIB_NORET, because it's already there!

2. Most of the single-occurrences (NORET_TYPE alone, without any
ATTRIB_NORET) were in function _implementations_. So here, what
we want is to simply remove the NORET_TYPE, and *not* introduce
any ATTRIB_NORET, because it's not required!

In such a situation, merging a patch that simply gets rid of
NORET_TYPE (i.e. s/NORET_TYPE//) actually ends up doing the
right thing!

... *however* ... as I mentioned next, unfortunately the above 2 points
did not hold for _all_ occurrences of NORET_TYPE. There were
some exceptions (which also I mentioned) where we want to do
somethings slightly more complicated, so I put the ball in Rday's
court -- he had originally expressed a wish to avoid doing complicated
things in this patch.
