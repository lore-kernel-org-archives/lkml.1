Return-Path: <linux-kernel-owner+w=401wt.eu-S1761773AbYDAVEt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761773AbYDAVEt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:04:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761296AbYDAVC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:02:56 -0400
Received: from mx5.orcon.net.nz ([219.88.242.55]:42748 "EHLO mx5.orcon.net.nz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759014AbYDAVCz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:02:55 -0400
Cc: Tyson Whitehead <twhitehe@uwo.ca>, Rene Herman <rene.herman@keyaccess.nl>,
       Takashi Iwai <tiwai@suse.de>, ALSA devel <alsa-devel@alsa-project.org>,
       linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, linux-alpha@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Message-Id: <CB76D24F-0C1F-4FDA-B6B0-4B842989718B@orcon.net.nz>
From: Michael Cree <mcree@orcon.net.nz>
To: rct@frus.com (Bob Tracy)
In-Reply-To: <20080401202605.70554DBA2@gherkin.frus.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [alsa-devel] [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
Date: Wed, 2 Apr 2008 10:02:37 +1300
References: <20080401202605.70554DBA2@gherkin.frus.com>
X-Mailer: Apple Mail (2.919.2)
X-DSPAM-Check: by mx5.orcon.net.nz on Wed, 02 Apr 2008 10:02:41 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Wed Apr  2 10:02:52 2008
X-DSPAM-Confidence: 0.8492
X-DSPAM-Improbability: 1 in 564 chance of being spam
X-DSPAM-Probability: 0.0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/04/2008, at 9:26 AM, Bob Tracy wrote:
> Hugh said we could blame him or Nick for removing the special
> PageReserved usage, or the Alpha for ignoring gfp_flags in the
> following:
>
>  #define dma_alloc_coherent(dev, size, addr, gfp)      \
>                pci_alloc_consistent(alpha_gendev_to_pci(dev), size,  
> addr)
>
> The workaround (until the official patch was issued) was a small patch
> against arch/alpha/kernel/pci_iommu.c:pci_alloc_consistent() that
> replaced "gfp_t gfp = GFP_ATOMIC;" with "gfp_t gfp = GFP_ATOMIC| 
> __GFP_COMP;".
> That eliminated the "bad page state" errors for me, and I don't recall
> what the official patch was.

The official patch has just been uploaded to the -mm kernel.  Get it at:

http://userweb.kernel.org/~akpm/mmotm/broken-out/alpha-fix-alsa-dma-mmap-crash.patch

It fixed up quite a number of sound playing applications that were  
causing kernel oops on my newer PWS600au (the older one still has  
problems that are of a completely different nature) and also fixed use  
of an M-Audio Revolution audio card on my XP1000.

The repeated small passages at the end of a short sound file still  
occurs with the es18xx driver on the newer PWS600au (and to a lesser  
extent on the Compaq XP1000).  Other sound drivers (cmipci, ice1724)  
do not exhibit the same anomalous symptoms so the problem is probably  
in the es18xx driver.

The older PWS600au fails to play sound at all and exhibits the  
behaviour you described in a recent message (machine gun like noises  
and the interrupts don't clock up at all) with the es18xx driver. I  
tried to put the C-Media audio card (which uses the cmipci driver)  
into this machine, but SRM reports on powerup that there is an  
"illegal" card installed (I hope the police don't turn up at my door)  
and that it must be removed to continue booting!!!  I tried setting  
pci_device_override to 1 in SRM, but that didn't help.  So I can't  
verify whether this is an es18xx specific problem or a more general  
alsa problem.

Now that the crashes due to "bad page state" errors are solved on both  
of my PWS600aus, maybe I should start re-applying the es18xx interrupt  
type patches that Tyson, et al., suggested and see if they now make a  
difference.  I will not be able to do this before the weekend.

Cheerz
Michael.

