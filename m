Return-Path: <linux-kernel-owner+w=401wt.eu-S1753523Ab0ADRQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0ADRQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 12:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753472Ab0ADRQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 12:16:28 -0500
Received: from mail-vw0-f192.google.com ([209.85.212.192]:48865 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab0ADRQ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 12:16:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qHJg4cpFmg5/tyaNfHtFQY6DzwgSkooR+PFnRPxaEmBAHBdQw3T7inqVjQr+02TOEi
         qBXSd4awm36WjjR8g7NyqTWvS55w2qlKjM9osOffZq2jbWnALaj7XAqCi6fDf2GfKbTs
         Z/8Vm8GX/5g+CPUggXepXmkYOzuHvdODVXSXE=
MIME-Version: 1.0
In-Reply-To: <20100104065755.GA26627@hallyn.com>
References: <20091223005447.GA28941@kroah.com>
	 <20100104065755.GA26627@hallyn.com>
Date: Mon, 4 Jan 2010 09:16:26 -0800
Message-ID: <a67e66b21001040916g1f70ae0eqfb66c77394251b2b@mail.gmail.com>
Subject: Re: Staging tree status for the .33 kernel merge
From: Ashwin Ganti <ashwin.ganti@gmail.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org, Eric Van Hensbergen <ericvh@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 3, 2010 at 10:57 PM, Serge E. Hallyn <serge@hallyn.com> wrote:
> Quoting Greg KH (greg@kroah.com):
> ...
>> This means, unless someone steps up and starts doing real work (not
>> trivial spelling fixes) on the following drivers, they will be removed
>> in the future kernel releases.
>>
>>  - arlan, netwave, strip, wavelan - wireless drivers mentioned above
>>    that are on the way out.  Slated for removal in 2.6.35
>>  - hv - Microsoft Hyper V drivers.  The developers again seem to have
>>    disappeared, this is getting old. Slated for removal in 2.6.35
>>  - p9auth - this will be removed in .34 unless someone steps up.
>
> I think I've decided to try to push it.  I'm working with some patches
> at git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-cr.git
> (branch p9auth.jan3.4 is latest).  I'll send patches as I feel they
> are ready - so far they pass testcases, but are too new for me to
> feel I should push them today.

Thanks Serge!

It is useful to continue to have this driver in the tree as there a
few other people as well who have shown interest in using this. I have
been recently contacted by guys at Glendix (http://www.glendix.org/)
who have started looking at using this driver.

>
> Ashwin, I'm curious whether you'd think the last patch
> (http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/sergeh/linux-cr.git;a=commitdiff;h=1662ba777140a39c21a9b647459d2deab8ffe1ca)
> would be a problem with any userspace - but I assume there is no
> legacy userspace to really worry about?

There is no legacy user space support yet for Linux. This should be
fine in that sense.
I still need to look at the patches in detail though but what is the
motivation for this change?
Please also cc rsc@swtch.com and ericvh@gmail.com as well when you
send out these patches for review.

>
> Apart from plenty more cleanups, another more fundamental issue to
> address is how to stop unused caphash entries from piling up in
> memory.  Put a timeout on them?  Let privileged userspace list and
> occasionally delete them?  Associate a target task with each entry,
> where either the task or its decendent can use the capability, but
> if the task dies we free the caphash entry?

So, there are a couple of options here (I favor the second approach):
1. We can add a timer to expire the capabilities.
2. Add a creation time stamp to every capability. Whenever a
capability is used (i.e. written to /dev/caphash) we can go through
the list in the kernel and reap the ones whose time stamp has expired.
We can optimize the data structure later to make this faster.

Ashwin.
