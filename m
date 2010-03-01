Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751264Ab0CARh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 12:37:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36586 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab0CARhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 12:37:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UNe0PbpVXOkV1p3CC0fv2UMyXbEvQ32Rl7zJjShAdcOfr67ETKH810FGEdb8SplPn1
         xZuH8t+iCJhWI6LdJhd4Y0tdfMLx6+WayJrWXtBYg5p5mtXIn87o2kJv8bdoEd0HT8tM
         KK7cPBUAPolxPTtG2L6hW0DDQsjKNstDN1mtU=
MIME-Version: 1.0
In-Reply-To: <2d460de71003010934m76594f4fk2e0b505b1867538c@mail.gmail.com>
References: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
	 <4807377b1002261152x6a92cfffl6ecb09d0574156d4@mail.gmail.com>
	 <2d460de71003010934m76594f4fk2e0b505b1867538c@mail.gmail.com>
Date: Mon, 1 Mar 2010 09:37:24 -0800
Message-ID: <4807377b1003010937x8cea2c8hf1518eafb230cd88@mail.gmail.com>
Subject: Re: New thread: page allocation failure with E1000 (seems to be 
	reproducible)
From: Jesse Brandeburg <jesse.brandeburg@gmail.com>
To: Richard Hartmann <richih.mailinglist@gmail.com>
Cc: e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Andrew Pochinsky <avp@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the future please copy netdev@vger.kernel.org on networking issues.

On Mon, Mar 1, 2010 at 9:34 AM, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:
> Hi Jesse,
>
>> the memory allocation (order:0), while unexpected, are not fatal, and
>> the e1000 driver is written to handle the failures during allocation.
>>
>> Does something else happen to the system after this or does operation continue?
>
> I can not be sure, but I _think_ some bogus data made it into userspace.
> I did have some binary in a text string I received & logged, which is a
> tad unusual.

hm, if that did occur it would be bad.  But it does sound like
operation continued, which is good.

>> You might be able to try the sysctl tweak to reserve a little more
>> memory for driver allocations.
>> # sysctl vm.min_free_kbytes
>> # sysctl -e vm.min_free_kbytes=<double what you have>
>
> I will try that, thanks.
>
>
>> have you increased the number of rx/tx descriptors in use by e1000?
>
> No. Should I?

I wouldn't recommend it if you're already having issues getting
order:0 allocations, it would just make the problem worse.  I wanted
to make sure you were not.

Jesse
