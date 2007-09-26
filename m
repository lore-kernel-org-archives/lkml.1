Return-Path: <linux-kernel-owner+w=401wt.eu-S1754972AbXIZPnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754972AbXIZPnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:43:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760278AbXIZPm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:42:56 -0400
Received: from s1.host3270.com ([216.146.143.173]:55706 "EHLO s1.host3270.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757768AbXIZPmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:42:54 -0400
X-Greylist: delayed 2559 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 11:42:54 EDT
Subject: Re: ACPI power off regression in 2.6.23-rc8 (NOT in rc7)
From: Tim Post <echo@echoreply.us>
Reply-To: echo@echoreply.us
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Damien Wyart <damien.wyart@free.fr>,
       LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
       Frans Pop <elendil@planet.nl>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org
In-Reply-To: <alpine.LFD.0.999.0709250830420.3579@woody.linux-foundation.org>
References: <20070925065109.GA3080@localhost.localdomain>
	 <20070925003340.5d6dd7f4.akpm@linux-foundation.org>
	 <alpine.LFD.0.999.0709250830420.3579@woody.linux-foundation.org>
Content-Type: text/plain
Organization: echoreply
Date: Wed, 26 Sep 2007 22:59:56 +0800
Message-Id: <1190818796.6259.58.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - s1.host3270.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - echoreply.us
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bah, its too damn stable. Break it and do it again.

>From 2.6.20.3 :

Boot time cut in half.
My PC no longer 'wakes up' angrily. My wife does that, I'm going to
start sleeping with the P4, its more agreeable now.

P4 HT with generic Intel chipset.

What fun is this when nothing breaks?

Thank you all :)

On Tue, 2007-09-25 at 08:40 -0700, Linus Torvalds wrote:
> 
> On Tue, 25 Sep 2007 08:51:09 +0200 Damien Wyart <damien.wyart@free.fr> wrote:
> > 
> > Hello,
> > 
> > After testing rc8, I noticed that I couldn't power off the computer
> > directly, it only got halted and I had to press the power button
> > manually. Just before displaying "System halted", the following message
> > is displayed:
> > 
> >   ACPI : PCI interrupt for device 0000:02:08.0 disabled
> > 
> > I had to first revert 5a50fe709d527f31169263e36601dd83446d5744 then
> > f216cc3748a3a22c2b99390fddcdafa0583791a2 (handling of Sx states) to
> > recover previous behaviour.
> 
> Hmm. Those things *do* seem to be suspicious.
> 
> For example, those commits seem to move code that used to be inside 
> CONFIG_PM (which pretty much *everybody* has) to be inside 
> CONFIG_ACPI_SLEEP (which is a totally different thing, and depends on 
> whether the user asked for suspend support or not!
> 
> Damien - does it work if you ask for SUSPEND or HIBERNATION support?
> 
> Len - why are you guys moving stuff into CONFIG_PM_SLEEP? I know you seem 
> to think that absolutely *everybody* should always support suspend and 
> hibernation, but the fact is, not everybody does. And it's a totally 
> separate thing for normal ACPI CPU runstate support that people have used 
> to manage a *running* CPU (and shutting it down).
> 
> 		Linus
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

