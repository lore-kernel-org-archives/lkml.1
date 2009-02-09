Return-Path: <linux-kernel-owner+w=401wt.eu-S1754291AbZBIFyO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754291AbZBIFyO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 00:54:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZBIFx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 00:53:57 -0500
Received: from smtp111.mail.mud.yahoo.com ([209.191.84.64]:45443 "HELO
	smtp111.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751141AbZBIFx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 00:53:56 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=3OZCAwccyIhd135Wf+4r3N095mMqElk3oyc5nMQ5Iflp2mTqwqnOAc7qHgfcOyJjpvEUDjJiPgcAs3zSiUbnwPy3upDeuRQ5Efb0JPibaWCZbHR60xsafCpzIGhe0ZYfQNdO9Ns8VKBMIpA6HdELUbEYtI6aPdwKeUinP6U4umw=  ;
X-YMail-OSG: t8wjAwgVM1knimXHmh5ttsMFN4Lo8SDDwbMSShWBL8MsTcvkbYI8mY3hHNBLIPeepnSFeE6.6Xj3sRP_kgw5CDjdaT7oiOGK6GWctubIj96tp_worSoHPXOQg2N4eVa9d5nPwi2xJmdScHp2l7HrtIl1RFIriXV2jSW1xCRycs0WZgp4z7o8eTvw68M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] x86: Add clflush before monitor for Intel 7400 series - v2
Date: Mon, 9 Feb 2009 16:53:25 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, H Peter Anvin <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>,
       "thomas@linux-os.sc.intel.com" <thomas@linux-os.sc.intel.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <20090207004728.GA17586@linux-os.sc.intel.com> <20090207140245.1e91a88f@lxorguk.ukuu.org.uk> <20090207164707.GA19149@linux-os.sc.intel.com>
In-Reply-To: <20090207164707.GA19149@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902091653.26570.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009 03:47:07 Pallipadi, Venkatesh wrote:
> On Sat, Feb 07, 2009 at 06:02:45AM -0800, Alan Cox wrote:
> > On Fri, 6 Feb 2009 16:47:29 -0800
> >
> > "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:
> > > For Intel 7400 series CPUs, the recommendation is to use a clflush on
> > > the monitored address just before monitor and mwait pair [1]. This
> > > clflush makes sure that there are no false wakeups from mwait when the
> > > monitored address was recently written to.
> >
> > Given our mwait usages will very quickly go back to sleep in such a case
> > and it would almost certainly be one sleep only is this really worth the
> > effort ?
>
> Yes. If we only consider the CPU idle behavior, we really do not need the
> patch as we will go back to idle. But, there are other factors:
> - drivers/idle/i7300_idle.c  which tries to save memory power based on CPU
>   idle time. It gets confused with these short idles.
> - cpuidle menu governor  These platforms may also support more than one
> C-state. C1 and CC3. So, we will go through the C-state policy in menu
> governor, which again looks at idle time and may end up taking wrong
> decisions due to these short idles.
>
> We can make the above code to be more clever, to ignore short idles. But,
> this patch seems to be the easier and clean way as the errata is only in a
> particular CPU model.

Have you benchmarked it? With something like tbench which IIRC should
generate a good number of idle/busy transitions?

