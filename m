Return-Path: <linux-kernel-owner+w=401wt.eu-S1755350AbZGFUgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755350AbZGFUgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:36:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754337AbZGFUgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:36:38 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:37024 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753549AbZGFUgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:36:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kg5KOs4le0qQ+pPsGtsKcP/zOmwtDIhtpyHEbgaRrV6ejdNxa70QZqE4d5boJKg1tD
         poxp7T8qJwBovS13uPA4hnhuLp/JjFUlbTQcWKgvQaweOdTzRg6Q0kMx1OWO06fSqCWG
         iyr8OrcO8w10651qg1tYMOV4NV0/Cm+o+mokc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org> <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain> 
	<1246513356.28915.62.camel@Joe-Laptop.home> <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain> 
	<1246556320.28915.92.camel@Joe-Laptop.home> <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain> 
	<1246910740.4643.10.camel@Joe-Laptop.home> <8bd0f97a0907061323j3480fa61sa7f44d71819a076d@mail.gmail.com> 
	<alpine.LFD.2.01.0907061332040.3210@localhost.localdomain>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Mon, 6 Jul 2009 16:36:19 -0400
Message-ID: <8bd0f97a0907061336p1a6e5113o4407ff28684310a2@mail.gmail.com>
Subject: Re: [PATCH] Remove multiple KERN_ prefixes from printk formats
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>, Yinghai Lu <yinghai@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 6, 2009 at 16:33, Linus Torvalds wrote:
> On Mon, 6 Jul 2009, Mike Frysinger wrote:
>> >  #ifdef CONFIG_DEBUG_VERBOSE
>> > -       printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
>> > +       printk(KERN_EMERG "Double Fault\n");
>>
>> dropped a newline.  we've largely made sure the newlines and such were
>> as we want in the output ... in this case, it is not a matter of
>> adding a newline where one did not exist before
>
> Note that the 'printk' itself will add a required newline these days.
>
> So unless you want an _empty_ line due to an earlier '\n', the change is
> correct.
>
> If you do want the empty line, it should looke like
>
>        printk(KERN_EMERG "\nDouble Fault\n");
>
> but I suspect that you had the '\n' there because you had a previous
> printk which hadn't ended the line (in which case just removing it and
> relying on the KERN_EMERG causing a line break is the right thing to do).

yes, the newlines here were explicit, not follow up to previous ones
missing lines.  i ignored the ones Joe (correctly) dropped due to
appending rather than explicit spacing.
-mike
