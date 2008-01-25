Return-Path: <linux-kernel-owner+w=401wt.eu-S1755999AbYAYPrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999AbYAYPrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 10:47:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYAYPr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 10:47:28 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:63529 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069AbYAYPr1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 10:47:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K9GvaioLfxUr0+wm8hpCmm8PcJwke9NPLSc+J/ufHM3nnKsaQZpay5GRMLQEUgVPrh2qIwxiGWh37HeDRd4QcoRxyWeOQVlOXFz9Z4qcqQnO7UVq04yYbIAp1QtiglS7zKneWRVvexwQMpbgPE7zzrhwUwDgvX0G5wMISYqR88A=
Message-ID: <a72f6a3c0801250747n4861d55vbab3bd35b26c8219@mail.gmail.com>
Date: Fri, 25 Jan 2008 15:47:24 +0000
From: "Jack Harvard" <jack.harvard@googlemail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: Q: linux failed to execute /init?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <a72f6a3c0801250734hdad822akce2808af7f9c4a83@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <a72f6a3c0801250538m57a91629o59242fad9e7d0265@mail.gmail.com>
	 <a72f6a3c0801250540l73aacf9bvcebf50c23da3943e@mail.gmail.com>
	 <Pine.LNX.4.64.0801251524510.15243@fbirervta.pbzchgretzou.qr>
	 <a72f6a3c0801250639i4a7858eem415594f5663a9c7e@mail.gmail.com>
	 <Pine.LNX.4.64.0801251601360.15243@fbirervta.pbzchgretzou.qr>
	 <a72f6a3c0801250734hdad822akce2808af7f9c4a83@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 25, 2008 3:34 PM, Jack Harvard <jack.harvard@googlemail.com> wrote:
>
> On Jan 25, 2008 3:02 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >
> >
> > On Jan 25 2008 14:39, Jack Harvard wrote:
> > >> On Jan 25 2008 13:40, Jack Harvard wrote:
> > >> >Hi,
> > >> >
> > >> >I'm trying to boot Linux, but the /init process failed. Here is the
> > >> >info:
> > >> >
> > >> >=FF<6>/init exit code: -14
> > >> >/init exit code: -14
> > >> ><4>Failed to execute /init
> > >> >Failed to execute /init
> > >> > <6>/sbin/init exit code: -14
> > >> >
> > >> >Just wondering what do those different exit codes mean?
> > >>
> > >> asm-generic/errno-base.h:#define EFAULT 14 /* Bad address */
> > >>
> > >
> > >Also, before the init process hung up and printed out /init exit code:
> > >-14, it printed out the following symbol
> > >ÿ
> > >Which doesn't make any sense to me, just wondering what could have
> > >caused this? it's unlikely due to baud rate and printed out something
> > >unreadable.
> >
> > ÿ is 255. While this could indicate a serial transmission error (my
> > guess: bad timing), printing -14 repeatedly certainly does not.
> > Is the ÿ reproducable, does it happen every time?
> >
>
> This is reproduceable and it happens every time. IMHO, I also suspect
> this could be caused by some obscure timing issues, as the kernel is
> booting up from an FPGA-prototyped SoC, the same Linux image was
> running fine on a previous build of FPGA-prototyped SoC,  but it's
> coming across this /init failed problem repeatedly on the currently
> running newly built bit file.
>

Here is the terminal printout from the correct bootup on a previous build.

<6>Freeing init memory: 584K
Freeing init memory: 584K
init started:  BusyBox v0.60.5 (2006.06.15-11:12+0000) multi-call binary
Bummer, could not run '/etc/init.d/rcS': No such file or directory
ÿ
Please press Enter to activate this console.

It looks that it's printing out several ÿ first and then replaced them
with "init started: BusyBox..." seems quite obscure, as the only
difference between those two FPGA builds is they were built at
different runs using exactly the same source files.
