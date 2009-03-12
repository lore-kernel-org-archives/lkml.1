Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZCLTFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZCLTFY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 15:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754218AbZCLTFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 15:05:09 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:33208 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753790AbZCLTFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 15:05:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CLgcZ6UpfN44bQhxYw7tDInYawIPS4eF+ar/tR1Vla1Gpo5CmFWSQGxz0fi/8a773A
         +wzygRABDOd+F9i00JPRTHODN3d155aQhxGSley2Ft5AM+qxFA6dT0XtXTOrku/m7Ij2
         pJ90m/SHN4j7nztT7h+HdG0/0vHWP+HRq1jKU=
MIME-Version: 1.0
In-Reply-To: <1236876609.5090.934.camel@laptop>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
	 <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
	 <fa686aa40903120901me307a54y3511f4bafc6242e6@mail.gmail.com>
	 <49B9362D.3090805@freescale.com> <1236876609.5090.934.camel@laptop>
Date: Thu, 12 Mar 2009 14:05:05 -0500
X-Google-Sender-Auth: a2619e9e05d953db
Message-ID: <ed82fe3e0903121205k552a83bft9ac3b63c64a293c8@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Timur Tabi <timur@freescale.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, will.newton@gmail.com,
       hancockrwd@gmail.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 11:50 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> sched_clock() does that, but:
>  - it falls back to jiffies on poor platforms

I think it's ok to fall back to jiffies where necessary, but these two
functions are too heavy-weight for my tastes.

> But something that seems to always work, is simply count loops and rely
> on whatever delay is in the specified loop.
>
> #define spin_until_timeout(condition, timeout, rc) \
>        for (unsigned long __timeout = 0; \
>             !(rc = (condition)) && __timeout < (timeout); \
>             __timeout++)

But that's the thing - I don't want a required delay inside the loop.

I guess I'm going to have to think about this for a while.  I'd like
to see something like cycles_per_usec() as a companion function to
get_cycles().

-- 
Timur Tabi
Linux kernel developer at Freescale
