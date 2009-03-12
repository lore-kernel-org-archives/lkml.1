Return-Path: <linux-kernel-owner+w=401wt.eu-S1756221AbZCLPy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbZCLPy7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 11:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753155AbZCLPyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 11:54:50 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:3572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752954AbZCLPyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 11:54:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NDt43yTBlqcpwhiPgQ5vy6sG7rr0zAvOkFTcqBNb6qjly45mL1oTcG0UwiP3Vu6Zfl
         iiZN2+l0+sO+eaUU97HQR7ETAoZxgftEX1NavuOVepA9NUnRPYbwrazDxiSwXn8dLR5/
         T0IfjODIdRWOBwbiQhOcCFb1ybLV0T9uia134=
MIME-Version: 1.0
In-Reply-To: <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
References: <1236699004-1863-1-git-send-email-timur@freescale.com>
	 <20090310153537.5fd5d84d@lxorguk.ukuu.org.uk>
	 <1236729711.7086.28.camel@pasglop>
	 <20090311003756.25ffa6f4@lxorguk.ukuu.org.uk>
	 <ed82fe3e0903110948w542a864dj821106900755f14e@mail.gmail.com>
	 <20090311165806.0b6838ab@lxorguk.ukuu.org.uk>
	 <49B80081.5060703@freescale.com> <1236808722.7086.66.camel@pasglop>
	 <fa686aa40903111945g53a0ba5au200fe9362e315175@mail.gmail.com>
Date: Thu, 12 Mar 2009 10:54:47 -0500
X-Google-Sender-Auth: d92e833a517cddc1
Message-ID: <ed82fe3e0903120854r2d8f23d8r249a8e510a2fbc4c@mail.gmail.com>
Subject: Re: [PATCH v4] introduce macro spin_event_timeout()
From: Timur Tabi <timur@freescale.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       rdreier@cisco.com, jirislaby@gmail.com, peterz@infradead.org,
       will.newton@gmail.com, hancockrwd@gmail.com, jeremy@goop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 11, 2009 at 9:45 PM, Grant Likely <grant.likely@secretlab.ca> wrote:

>> The other big advantage of that approach is that drivers that aren't in
>> an atomic section can use msleep() and allow the kernel to schedule on
>> that processor.
>
> Ack!  I totally agree.

I'm glad everyone agrees.  I still don't know how to solve the
problem, though.  I came up with this:

#define spin_until_timeout(condition, timeout)          \
       for (unsigned long __timeout = jiffies + (timeout);     \
               (!(condition) && time_after(jiffies, __timeout)); )

Now how do I modify this so that the caller knows whether the loop
terminated because of a timeout or the condition became true?

-- 
Timur Tabi
Linux kernel developer at Freescale
