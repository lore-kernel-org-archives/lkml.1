Return-Path: <linux-kernel-owner+w=401wt.eu-S1946551AbXD3SOJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946551AbXD3SOJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 14:14:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945895AbXD3SOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 14:14:08 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:13482 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946552AbXD3SOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 14:14:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mJ0lF5gCZ13n7rCxwI0rWwcCAPqqzrKOjQTkZcvI0sCwgaJFfK/cHcULHhyajKke0ORPhKpyTOuQDZvJTybAZVGQUikjaity9chVn+WrYB8dtxxUpd1+sxFczVk2VpAhLZfi4A47YzrA0H565gOHsgcRc2LJUTgiLDUbaVpuDMw=
Message-ID: <4af2d03a0704301114sc84b358td8781c91b8564c38@mail.gmail.com>
Date: Mon, 30 Apr 2007 20:14:05 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: 2.6.21-mm1: many processes end up in D state
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070430110510.1f559d34.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46360DA7.6040003@gmail.com>
	 <20070430110510.1f559d34.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Mon, 30 Apr 2007 17:39:19 +0200
> Jiri Slaby <jirislaby@gmail.com> wrote:
>
> > Hi,
> >
> > I have a problem with higher disk loads (e.g. running git-log or yum update).
> > Many processes end up in D state and system is unusable -- I'm not able to run
> > anything but smooth mouse moving when this happens.
> >
> > If I wait for a 20-30sec it becomes usable. This happens in 2.6.21-rc7-mm2 and
> > also in 2007-04-28-05-06 broken-out snapshot. I think 2.6.21-rc6-mm1 worked
> > fine, but I'm uncertain. If it is important, let me know to re-test.
> >
>
> It is important, but I doubt if retesting 2.6.21-rc6-mm1 will clarify
> things a lot.
>
> Could you try switching to a different IO scheduler please?  Anticipatory
> would suit.

As I wrote below the sysrq-t, switch to noop didn't help, but it seems
that it's harder to reproduce with that:

<cite it's_bad_to_write_anything_below_logs="true">
Note that yum works on lvm on raid0 and git too, but on the another md volume.
Both ext3s. Drivers are sata_promise and ata_piix (sata disk); CFQ scheduler.
Using noop is no change (but seems to be harder to reproduce with it). I figured
out that it probably happens when 2+ processes are on both "processors" (HT on
P4) and are IO wait (multiload-applet shows red above the half).

Swap usage is 0 all the time.
</cite>

> Please keep a close eye on mainline, too.  Wait for it to appear there :(

Ok, I'll try to play with that...

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
