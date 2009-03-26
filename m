Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbZCZVGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbZCZVGL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 17:06:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753177AbZCZVF4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 17:05:56 -0400
Received: from mk-outboundfilter-6-a-2.mail.uk.tiscali.com ([212.74.114.16]:58090
	"EHLO mk-outboundfilter-6-a-2.mail.uk.tiscali.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505AbZCZVFz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 17:05:55 -0400
X-Greylist: delayed 624 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Mar 2009 17:05:55 EDT
X-Trace: 88383822/mk-outboundfilter-6.mail.uk.tiscali.com/F2S/$F2S-ACCEPTED/f2s-freedom2Surf-customers/83.67.11.44/None/tvrtko@ursulin.net
X-SBRS: None
X-RemoteIP: 83.67.11.44
X-IP-MAIL-FROM: tvrtko@ursulin.net
X-MUA: KMail/1.9.10
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAFKIy0lTQwss/2dsb2JhbACBUNMxg3cG
X-IronPort-AV: E=Sophos;i="4.38,428,1233532800"; 
   d="scan'208";a="88383822"
X-IP-Direction: IN
From: "Tvrtko A. Ursulin" <tvrtko@ursulin.net>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Resume after hibernation regression in 2.6.29
Date: Thu, 26 Mar 2009 20:55:23 +0000
User-Agent: KMail/1.9.10
Cc: linux-pm@lists.linux-foundation.org, rjw@sisk.pl,
       kernel list <linux-kernel@vger.kernel.org>
References: <200903261920.32173.tvrtko@ursulin.net> <20090326201840.GB29836@elf.ucw.cz>
In-Reply-To: <20090326201840.GB29836@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903262055.23749.tvrtko@ursulin.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 March 2009 20:18:40 Pavel Machek wrote:
> On Thu 2009-03-26 19:20:32, Tvrtko A. Ursulin wrote:
> > Hi guys,
> > I have been running custom compiled 2.6.28.7 in OpenSUSE 11.1 and using
> > hiberation/resume daily as configured by the distro. Yesterday I upgraded
> > to 2.6.29 (make oldconfig from 2.6.28.7, attached) and after resume
> > networking (at least) does not work. Reboot at this point takes very long
> > because of timeouts on CIFS and whatelse.
> >
> > Below is how /var/log/messagess looks for one cycle
> > (hibernate-resume-reboot) and I am also attaching kernel config and
> > /var/log/pm-suspend.log.
> >
> > You will probably notice evil nvidia.ko in there but don't panic, it all
> > happens without it as well. Tested from runlevel 3 and by running
> > pm-hibernate. After resume from that NIC LEDs were off. I
> > tried /etc/init.d/network restart but that hung so I ^C and tried rmmod
> > forcedeth && modprobe forcedeth && ifup eth0 and after some time network
> > went live again. Haven't had time to test further though, so this is all
> > pretty rough.
>
> Ok, can you try to rmmod forcedeth before hibernation, then insmod it
> after resume?

Sure, after insmod and /etc/init.d/network start following resume network was 
fine. Guess I could kludge that sequence into pm scripts somehow but would 
rather avoid that since it slows down the cycle and would make scripts 
non-stock.

Tvrtko
