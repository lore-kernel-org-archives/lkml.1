Return-Path: <linux-kernel-owner+w=401wt.eu-S932560AbZACDp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932560AbZACDp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:45:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758809AbZACDpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:45:20 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:34140 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806AbZACDpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:45:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=aMDiq7m76wTYC6mkaLDF8bBsYmua42i7fv56U42j/tHDyv7sl3ZcQOxpN+6WvcdU/0
         84DZlE3Ocr5SAuPvWi0bLB+Ge13JZuuIFxkF0evTZIZrUh+O6KXW7+kaKZn1Mk8c3O3n
         zsOvT2VvmLbPeiopSJkunG4Snlrs+qGAYhQgQ=
Message-ID: <3ae3aa420901021945w3d8f8065p2cd3e4f649849a2e@mail.gmail.com>
Date: Fri, 2 Jan 2009 21:45:16 -0600
From: "Linas Vepstas" <linasvepstas@gmail.com>
Reply-To: linasvepstas@gmail.com
To: "Duane Griffin" <duaneg@dghda.com>
Subject: Re: Bug: Status/Summary of slashdot leap-second crash on new years 2008-2009
Cc: "Chris Adams" <cmadams@hiwaay.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20090103022358.GA2454@dastardly.home.dghda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <20090103022358.GA2454@dastardly.home.dghda.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/1/2 Duane Griffin <duaneg@dghda.com>:
> On Fri, Jan 02, 2009 at 06:21:14PM -0600, Chris Adams wrote:
>> Once upon a time, Linas Vepstas <linasvepstas@gmail.com> said:
>> > Below follows a summary of the reported crashes. I'm ignoring the
>> > zillions of "mine didn't crash" reports, or the "you're a paranoid
>> > conspiracy theorist, its random chance" reports.
>>
>> I have reproduced this and got a stack trace (this is with Fedora 8 and
>> kernel kernel-2.6.26.6-49.fc8.x86_64):
>>
>> Basically (to my untrained eye), the leap second code is called from the
>> timer interrupt handler, which holds xtime_lock.  The leap second code
>> does a printk to notify about the leap second.  The printk code tries to
>> wake up klogd (I assume to prioritize kernel messages), and (under some
>> conditions), the scheduler attempts to get the current time, which tries
>> to get xtime_lock => deadlock.
>
> How about just moving the printk out of the lock? I.e. something like
> this:

[...]

Sure looks like the right fix to me.  (Although there's more than
one printk under that lock).  Who's going to write the formal patch?

--linas
