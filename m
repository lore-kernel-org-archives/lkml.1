Return-Path: <linux-kernel-owner+w=401wt.eu-S1760252AbYBBRJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252AbYBBRJF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 12:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYBBRIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 12:08:53 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46350 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbYBBRIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 12:08:52 -0500
Date: Sat, 2 Feb 2008 18:08:28 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <gregkh@suse.de>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net,
       linux-scsi <linux-scsi@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [patch] pci: pci_enable_device_bars() fix
Message-ID: <20080202170828.GA12748@elte.hu>
References: <20080201231147.GA18174@suse.de> <20080202111322.GA30767@elte.hu> <47A49171.2000003@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A49171.2000003@garzik.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeff Garzik <jeff@garzik.org> wrote:

> Ingo Molnar wrote:
>> ===================================================================
>> --- linux.orig/drivers/scsi/lpfc/lpfc_init.c
>> +++ linux/drivers/scsi/lpfc/lpfc_init.c
>> @@ -1894,7 +1894,7 @@ lpfc_pci_probe_one(struct pci_dev *pdev,
>>  	uint16_t iotag;
>>  	int bars = pci_select_bars(pdev, IORESOURCE_MEM);
>>  -	if (pci_enable_device_bars(pdev, bars))
>> +	if (pci_enable_device_io(pdev))
>>  		goto out;
>
> Look at the line right above it...  AFAICS you want 
> pci_enable_device_mem(), if the mask is selecting IORESOURCE_MEM BARs.
>
> Also a CC to linux-scsi and the driver author would be nice, as they 
> are the ones with hardware and can verify.

it would have been totally appropriate for me to just send a mail to 
lkml with the proper subject line about the breakage. (I might even have 
decided to stay completely silent about the issue and fix it for my own 
build, letting you guys figure it out.)

Instead i did a search of lkml (based on the function name in the build 
error) and figured out where the pull request was on lkml: Greg. I 
replied to that mail, he'll obviously know whom else to Cc from that 
point on (if anyone). I really didnt want to (nor did i need to) figure 
out whether this was some general driver level API change that happen 
kernel-wide, or some SCSI specific change. I simply replied to the pull 
request whose Cc: line seemed well-populated to me already. I also took 
a look at the commit itself and did a quick hack in a hurry to keep the 
tests rolling. It really did not occur to me that i should have added 
anyone else to the Cc: line, as linux-pci@atrey.karlin.mff.cuni.cz was 
Cc:-ed already so i assumed the interest was from that angle.

( And as this was spent from my family's weekend time and i had no time
  and no interest to dig any further than to figure out the "first hop"
  of the change that broke the build, and the parties who initiated that
  hop. I'm in fact surprised that your and James's answer to my
  bugreport is hostility. )

So i find your suggestion that i should have added more people to the 
Cc: line unfair on several levels.

> This set of changes seemed like 50% guesswork to me, without 
> consulting the authors :( And unlike many changes, you actually have 
> to know the hardware [or get clues from surrounding code] to make the 
> change.

you mean the whole set of changes? Or just mine? Mine was a 30 seconds 
guesswork of course, i dont have the hardware, i didnt do the change, 
nor did i do anything near that code - i just saw the build failure stop 
my testing and sent in this notification and a hack. That's why i sent 
it to Greg, as a reply to the mail where he pushed these changes 
upstream and who'll know what to do with it from that point on. My patch 
can be totally thrown away (and should be, apparently).

but ... i guess next time i'll think twice before sending any bugreports 
about or related to the SCSI code anywhere, unless they become really 
annoying. Who needs this hassle?

	Ingo
