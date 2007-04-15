Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXDOQHI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXDOQHI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 12:07:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753031AbXDOQHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 12:07:07 -0400
Received: from wr-out-0506.google.com ([64.233.184.233]:6851 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbXDOQHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 12:07:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=FRw3VgUEu5JOkha9d3YUWRZykgIHocZpb/+vF8rxyE485GlllxFVx2GhY2Mc2sbEqlXal8UfT9euus5w0ruE+kfhbt+ONVJEH0kqvEDnY12kC59GzpTX9lbBY6t1YfgM1Le1MlrRh2Q1qomcVkmcr5DRcmQTEfh8D47iqHweyCg=
Message-ID: <414cba4e0704150907r215bf196n637070dd40bccc3b@mail.gmail.com>
Date: Sun, 15 Apr 2007 18:07:04 +0200
From: emisca <emisca.ml@gmail.com>
To: "Chuck Ebbert" <cebbert@redhat.com>
Subject: Re: Loud "pop" coming from hard drive on reboot
Cc: "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
In-Reply-To: <461D54AF.3060706@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <461D4E2C.6000704@redhat.com>
	 <Pine.LNX.4.61.0704112315480.20436@yvahk01.tjqt.qr>
	 <461D54AF.3060706@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I can confirm this, I have a Seagate Momentus 5400.3 sata disk, and it
spins off, respin up and again off when I halt my notebook.
I had before this disk an IBM/Hitachi one, and it doesn't have this behaviour.

Take a look at this bug report:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.17/+bug/67810

There are some references and some patches against 2.6.20 kernel. This
bug is confirmed there.

Bye

2007/4/11, Chuck Ebbert <cebbert@redhat.com>:
> Jan Engelhardt wrote:
> > On Apr 11 2007 17:07, Chuck Ebbert wrote:
> >> When I reboot my notebook, it powers off and powers back on.
> >> On poweroff a loud snapping noise seems to be coming from the
> >> hard drive. Today I noticed there is no "shutdown: hda" on
> >> the console when I reboot. Whne I do a normal poweroff the
> >> message is displayed and there is no noise. Should the IDE
> >> code be changed so it always shuts down the drive?
> >
> > What sort of notebook? What sort of harddisk?
>
> Compaq Presario V2000 series, with a new Seagate ST9120821A
> 120GB 5400RPM drive.
>
> > Is it as loud as `hdparm -y /dev/hdX"?
>
> That makes no noise at all except normal drive seek noises.
>
> > Try `smartctl -d ata -a /dev/hdX | grep -i unload` too.
>
> Hmm.
>
> Power_Cycle_Count ... 108
> Power-Off_Retract_Count ... 90
>
> I did a normal poweroff and the retract count went to 91.
> There is an almost-unnoticeable click when I do it that way.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
