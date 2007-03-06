Return-Path: <linux-kernel-owner+w=401wt.eu-S1030417AbXCFWlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417AbXCFWlO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 17:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932632AbXCFWlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 17:41:14 -0500
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:21871 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932627AbXCFWlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 17:41:13 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=33TQqrJes7BRwOpOmieoN2rnJA+OdYy485rd+U59GT48ArZ1p/MD3qFfF6oxpbs2b1KttUEmCx5FB296kltwCdpmRsGwvDJbXWedZnTXCJdRV4tUxrdZHIY+NrVmA1MzrNsBha7WfXZjKHZcGZNAiQH62540uOM+CQjn9bCUBGI=  ;
X-YMail-OSG: FnT2LFoVM1n.O6hNK10j3rOa38qpbcwEBRmmTWei9DvQF1OuStrsYe6nemSOFSUBFyhD2ipFhvRiyHuPUoVbPXIkKGFVLQbAwr26wP74ad9GkVgZCQQDDBa6WVc1H1tkUFWgfQiLp5giHf5Jzgf3o9erJw--
From: David Brownell <david-b@pacbell.net>
To: Alessandro Zummo <alessandro.zummo@towertech.it>
Subject: Re: [rtc-linux] Re: 2.6.21-rc2 : Oops in rtc_cmos...
Date: Tue, 6 Mar 2007 14:23:40 -0800
User-Agent: KMail/1.7.1
Cc: rtc-linux@googlegroups.com, rol@as2917.net,
       "'Adrian Bunk'" <bunk@stusta.de>, linux-kernel@vger.kernel.org,
       a.zummo@towertech.it
References: <01b901c75fc1$2295d4c0$4b00a8c0@donald> <200703061132.29331.david-b@pacbell.net> <20070306215023.1ec0a4d7@inspiron>
In-Reply-To: <20070306215023.1ec0a4d7@inspiron>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703061423.42118.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 March 2007 12:50 pm, Alessandro Zummo wrote:
> On Tue, 6 Mar 2007 11:32:28 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > > on then... My dmesg says, related to rtc :
> > > 
> > > ...
> > > rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> > 
> > I think the RTC core shouldn't emit this message; I'll send
> > a patch.  It's just confusing on error paths; and on success
> > paths it's less informative than a message from the driver
> > itself could be.
> 
>  I would like a way to have a common "welcome" message among
>  all the drivers. Please take this into account if you want
>  to send a patch ;)

Well, I already sent such a patch.  :)

I don't much object to such a message, although it's not
necessary ... and "not necessary" is all but synonymous
with being syslog spam.


> > > What does this all mean ? I thought an RTC Cmos was always there on a
> > > standard PC motherboard... (that's why I had activated the option in the
> > > first time).
> > 
> > You enabled CONFIG_RTC (under char drivers, "Enhanced Real Time Clock Support")
> > so that driver has claimed the CMOS RTC instead of "rtc-cmos.c".  Disable it.
> > Then you'll be able to use this driver with no little surprises.
> 
>  maybe we should consider this in the Kconfig.

Kconfig for both drivers, ideally:  select one, the other becomes unavailable.
Someone could generate such a patch...

- Dave
