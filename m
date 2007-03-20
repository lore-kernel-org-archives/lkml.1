Return-Path: <linux-kernel-owner+w=401wt.eu-S965543AbXCTRNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965543AbXCTRNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 13:13:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965550AbXCTRNx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 13:13:53 -0400
Received: from mail.chilan.com ([82.160.212.9]:39936 "EHLO mail.chilan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965543AbXCTRNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 13:13:52 -0400
X-Greylist: delayed 1606 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 13:13:52 EDT
From: "Grzegorz Chwesewicz" <grzegorz.chwesewicz@chilan.com>
To: "Stefan Prechtel" <stefan.prechtel@googlemail.com>, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, "Len Brown" <lenb@kernel.org>,
       "Andi Kleen" <ak@suse.de>, "john stultz" <johnstul@us.ibm.com>
Subject: Re: BUG lapic: Can't boot on battery (2.6.21-rc{1,2,3,4})
Date: Tue, 20 Mar 2007 17:47:02 +0100
Message-Id: <20070320164604.M60273@chilan.com>
In-Reply-To: <b93822910703200123g5b3ac0e4n1ba1122a7e90a838@mail.gmail.com>
References: <b93822910703191010s1ac9d5d7jf9f761ecb933cc77@mail.gmail.com> <1174326499.13341.517.camel@localhost.localdomain> <b93822910703191153x20249f00vb604a0eda075a23a@mail.gmail.com> <1174332477.13341.561.camel@localhost.localdomain> <b93822910703191249i40a70418ka8165da52070ae82@mail.gmail.com> <1174334646.13341.577.camel@localhost.localdomain> <b93822910703191335i236cdc4av59cc9fd0685537ec@mail.gmail.com> <1174337777.13341.621.camel@localhost.localdomain> <b93822910703191451o216a8931v9023b174fdef750@mail.gmail.com> <1174353329.13341.762.camel@localhost.localdomain> <b93822910703200123g5b3ac0e4n1ba1122a7e90a838@mail.gmail.com>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 82.160.213.5 (ceho)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have HP nx6325. I've tried to use WARN_ON_ONCE patch, but I don't see
nothing special in dmesg. Just in case I'm posting my
dmesg_2.6.20_WARN_ON_ONCE_on_battery log on
http://bugzilla.kernel.org/show_bug.cgi?id=8235 .

Below I post output of my /proc interrupts (10 sec. delay between reads).

#########################

2.6.20_ac:

           CPU0       CPU1
  0:      73190          0  local-APIC-edge-fasteio   timer
LOC:      72967      72966

           CPU0       CPU1
  0:      83196          0  local-APIC-edge-fasteio   timer

LOC:      82974      82973

#########################

2.6.20_battery:

           CPU0       CPU1
  0:     468590          0  local-APIC-edge-fasteio   timer
LOC:     468410     468409

           CPU0       CPU1
  0:     478596          0  local-APIC-edge-fasteio   timer
LOC:     478417     478416

#########################

2.6-git_ac:

           CPU0       CPU1
  0:        262          0  local-APIC-edge-fasteoi   timer
LOC:      66041      66041

           CPU0       CPU1
  0:        262          0  local-APIC-edge-fasteoi   timer
LOC:      76067      76067

#########################

2.6-git_battery:

           CPU0       CPU1
  0:        261          0  local-APIC-edge-fasteoi   timer
LOC:      29007      29015

           CPU0       CPU1
  0:        261          0  local-APIC-edge-fasteoi   timer
LOC:      29189      29200

#########################

Other interesting thing on 2.6-git is that when I press a key on keyboard it
doesn't repeat (on battery), but it repeats on 2.6-git on ac.

--
Greetings - Grzegorz Chwesewicz
