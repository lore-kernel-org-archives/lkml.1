Return-Path: <linux-kernel-owner+w=401wt.eu-S1752313AbYFUP07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbYFUP07 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 11:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751101AbYFUP0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 11:26:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60041 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751094AbYFUP0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 11:26:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: linux-next: Tree for June 20: [regression] No sound on SB600
Date: Sat, 21 Jun 2008 17:28:09 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20080620172507.b7301bd1.sfr@canb.auug.org.au>
In-Reply-To: <20080620172507.b7301bd1.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806211728.10445.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 20 of June 2008, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080619:
> 
> The net tree lost its conflict against Linus' tree.
> 
> The bkl-removal tree lost a conflict.

On one of my test boxes with the ATI chipset (SB600 south bridge) there's no
sound output.  Bisection shows that the following commit causes this to happen
and reverting the commit fixes the problem for me:

commit cf97e6678f1e1e7bbdb566c36771540123832a31
Author: Takashi Iwai <tiwai@suse.de>
Date:   Mon Jun 16 15:47:26 2008 +0200

    ALSA: hda - Fix wrong volumes in AD1988 auto-probe mode
    
    Don't create mixer volume elements for Headphone and Speaker if they
    use the same DAC as normal line-outs on AD1988.  Otherwise the amp
    value gets screwed up, e.g.
    	https://bugzilla.novell.com/show_bug.cgi?id=398255
    
    Signed-off-by: Takashi Iwai <tiwai@suse.de>

Please let me know if you need any additional information.

Thanks,
Rafael
