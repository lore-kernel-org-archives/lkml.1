Return-Path: <linux-kernel-owner+w=401wt.eu-S1754866AbXHZTTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbXHZTTP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 15:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbXHZTS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 15:18:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:18632 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751528AbXHZTS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 15:18:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=V83q7BO8rESMV+xT0Tb+3UcJT1TBWYVYVgQdeJC2igWohsSAAGR1iy0yj+oXcznxyogom+qOBVxoF3ZTVUHwwBQV2McvrV/+ICxKZpuNTJW8y6CL77G5MoZEbzPjz/pFax2/KMgrtQY5bwSrAO8tQTaxoAwDncyoRmDedwmAy0k=
Message-ID: <4877c76c0708261218r2c1ed2eeg6d604eeb58f6b235@mail.gmail.com>
Date: Sun, 26 Aug 2007 12:18:56 -0700
From: "Michael Evans" <mjevans1983@gmail.com>
To: "Randy Dunlap" <randy.dunlap@oracle.com>
Subject: Re: [patch v2 1/1] md: Software Raid autodetect dev list not array
Cc: "Michael J. Evans" <mjevans1983@comcast.net>, "Neil Brown" <neilb@suse.de>,
       "Ingo Molnar" <mingo@redhat.com>, linux-raid@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070826095651.75e92556.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200708222058.45480.mjevans1983@comcast.net>
	 <18126.21113.981032.286298@notabene.brown>
	 <200708260451.24868.mjevans1983@comcast.net>
	 <20070826095651.75e92556.randy.dunlap@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Sun, 26 Aug 2007 04:51:24 -0700 Michael J. Evans wrote:
>
> > From: Michael J. Evans <mjevans1983@gmail.com>
> >

>
> Is there any way to tell the user what device (or partition?) is
> bein skipped?  This printk should just print (confirm) that
> node_detected_dev is NULL.  Shouldn't it just print <dev> in
> major:minor format?
>

It would be possible with the MAJOR() and MINOR() macros to do this...
however it doesn't really help out much during troubleshooting. I
tried using the bdevname function like the function that calls this
one uses, however, it wants a struct device_block... which I tried
getting with:

container_of(dev, struct block_device, bd_dev)

Of course this didn't quite work out, I got kernel panics on my two
trial attempts.

Here's a skip from a dmesg where I added a printk right under the line
in question.

[   63.033532] sd 11:0:0:0: [sdk] 976773168 512-byte hardware sectors
(500108 MB)
[   63.039842] sd 11:0:0:0: [sdk] Write Protect is off
[   63.046012] sd 11:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   63.046025] sd 11:0:0:0: [sdk] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   63.052309]  sdk: sdk1 sdk2 sdk3 sdk4 sdk5 sdk6 sdk7 sdk8 sdk9
sdk10 sdk11 sdk12 sdk13 sdk14 sdk15
[   63.082546] md: Autodetect-buffering the above device.
[   63.088893] md: Autodetect-buffering the above device.
[   63.095053] md: Autodetect-buffering the above device.
[   63.101082] md: Autodetect-buffering the above device.
[   63.106956] md: Autodetect-buffering the above device.
[   63.112596] md: Autodetect-buffering the above device.
[   63.117998] md: Autodetect-buffering the above device.
[   63.123396] md: Autodetect-buffering the above device.
[   63.128789] md: Autodetect-buffering the above device.
[   63.134182] md: Autodetect-buffering the above device.
[   63.139576] md: Autodetect-buffering the above device.
[   63.144970] md: Autodetect-buffering the above device.
[   63.150360] md: Autodetect-buffering the above device.
[   63.155749] md: Autodetect-buffering the above device.
[   63.161498] sd 11:0:0:0: [sdk] Attached SCSI disk


> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
