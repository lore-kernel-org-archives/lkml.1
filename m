Return-Path: <linux-kernel-owner+w=401wt.eu-S1754589AbYEWLs6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754589AbYEWLs6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 07:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYEWLst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 07:48:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:42059 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYEWLss convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 07:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=KNHSKthVh1I3ycs+TT5KZA2A5QHsMdjDPxcjgXpEqSE1JpAcHugQhvGupGIVBHPnnEJ97n8PL51UQTG8OskvyvnAEQ4jO5w7HNwtAKxXnbV9/RSKEhqZ3om9bPt1z2Kp1zyySa8afsDb5/3vKATje1xC9ieC69IwEiDOClCV7wQ=
Message-ID: <7b9198260805230448x56bf3bd1kade6083c141a75f2@mail.gmail.com>
Date: Fri, 23 May 2008 12:48:46 +0100
From: "Tom Spink" <tspink@gmail.com>
To: "=?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?=" <Uwe.Kleine-Koenig@digi.com>
Subject: Re: [PATCH 1/1] UIO: Add a write() function to enable/disable interrupts
Cc: "Hans J. Koch" <hjk@linutronix.de>, linux-kernel@vger.kernel.org,
       "Greg Kroah-Hartman" <gregkh@suse.de>,
       "Jan Altenberg" <jan.altenberg@linutronix.de>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Magnus Damm" <magnus.damm@gmail.com>
In-Reply-To: <20080523054115.GB28807@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <20080522192252.GB3226@local> <20080522192637.GC3226@local>
	 <7b9198260805221247t715660d1l4085fe8c310f89c@mail.gmail.com>
	 <20080522200814.GD3226@local>
	 <7b9198260805221326t6d23b757p2ffe646db70fceba@mail.gmail.com>
	 <20080523054115.GB28807@digi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/23 Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>:
> Hello Tom,

Hi Uwe,

> Tom Spink wrote:
>> The added benefit is that the code becomes less complex, as you don't
>> have to check buffer sizes and copy the integer from userspace.
> AFAIK this is wrong.  You need to copy the integer from userspace in
> uio_ioctl.  Actually it's a value coming from user space, so you need to
> do it somewhere.

Not really in this case.  It's not a *pointer* to a value in
userspace, so you don't need to copy anything.  If it was being used
to point to a memory location holding a value, then yes, it would need
to be copied across.  But in this case, it's just being used to pass
across 1 or 0.

For example, look at the drivers/char/tty_ioctl.c file, and see how
they use arg as a simple value.  arg doesn't have to be a pointer to
userspace.

> Best regards
> Uwe

-- 
Tom Spink
