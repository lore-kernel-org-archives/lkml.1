Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZC2Anb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZC2Anb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 20:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751351AbZC2AnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 20:43:21 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:40093 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052AbZC2AnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 20:43:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=OVx+n3ILaH7eO3dC7yG8pkrJb6iB5m+L+hr9TMS64a9JrHULXECysYqrmRB3fL1L1h
         bKAQUtt0zFxi1rjwbEQahwRW+tae1+T8DE52gW6cQ7NX/DbTWPkNUDlrs/v/Tkk9qRVT
         92n39XSztuw+EyqSgbJReB3cAmsuYV6QLIAYw=
MIME-Version: 1.0
In-Reply-To: <49CE102C.604@freenet.de>
References: <49CE102C.604@freenet.de>
Date: Sat, 28 Mar 2009 17:43:18 -0700
Message-ID: <e9c3a7c20903281743o2b9f7aa5yc60a330fee6de2ba@mail.gmail.com>
Subject: Re: 2.6.29 - raid10 issue - spares do not get synched automatically
From: Dan Williams <dan.j.williams@gmail.com>
To: Patrick Ringl <patrick_@freenet.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 4:55 AM, Patrick Ringl <patrick_@freenet.de> wrote:
> Hello,
>
> I am using 2.6.29 on a debian lenny. Anyway, I am having problems with a
> raid10 sandbox setup consisting of 4 loopback devices. To make a long story
> short:
>
> I created a raid10 array with all these 4 devices (loop0-loop3)
> then I set two devices faulty, removed them .. checked if I can still write
> to the array (which I could, so I/O errors, nothing in dmesg):
>
> BUT - here it comes: once I am trying to (re)add them (I zero'ed the
> superblock before) they're only getting added as spares and the array will
> not sync.
>
> Here's the logfile with mdadm -D /dev/md0 in between so one can see what is
> going on:
>
> http://paste.debian.net/31758/
>
>
> Any ideas?

You failed the whole array.  With 4 devices in the default layout the
array looks like stripe(mirror(slot0, slot1), mirror(slot2, slot3)).
In your case mdadm -D shows that you have the loop devices in the
following slots stripe(mirror(loop2, loop0), mirror(loop1, 3)).  A
raid10 is failed once all devices in a mirror set are failed, and a
failed array can't be rebuilt.

Regards,
Dan
