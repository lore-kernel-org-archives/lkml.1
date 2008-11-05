Return-Path: <linux-kernel-owner+w=401wt.eu-S1756296AbYKEQYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbYKEQYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 11:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbYKEQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 11:24:09 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:54085 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752237AbYKEQYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 11:24:07 -0500
X-Sasl-enc: W1plxOFCZDAdO4XetcDe4ZIojHzFWaxuo3OOROrvKuUD 1225902245
Date: Wed, 5 Nov 2008 14:24:01 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] Fan level 7 after resume wit 2.6.28-rc3
Message-ID: <20081105162401.GF14931@khazad-dum.debian.net>
References: <20081105073306.GA3132@x61> <20081105074712.GA2816@x61> <20081105122632.GC14931@khazad-dum.debian.net> <20081105130852.GB30758@dose.home.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081105130852.GB30758@dose.home.local>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 05 Nov 2008, Tino Keitel wrote:
> On Wed, Nov 05, 2008 at 10:26:32 -0200, Henrique de Moraes Holschuh wrote:
> > On Wed, 05 Nov 2008, Tino Keitel wrote:
> > > On Wed, Nov 05, 2008 at 08:33:08 +0100, Tino Keitel wrote:
> > > > I tried 2.6.28-rc3 (git a75952b) on my ThinkPad X61s, and now the fan
> > > > runs at full speed after resume from suspend:
> > > 
> > > I forgot to look into the kernel logs for more info. Well, I found this
> > > line:
> > > 
> > > thinkpad_acpi: restoring fan level to 0x07
> > > 
> > > So I guess that according to
> > > 
> > > ACPI: thinkpad-acpi: attempt to preserve fan state on resume
> > > 
> > > the attempt failed. :-)
> > 
> > Indeed.  Please send the full kernel output of thinkpad-acpi, showing boot,
> > suspend and resume messages from the driver, please?
> 
> See http://tikei.de/kernel.log
> 
> > Also, please tell me what is the contents of /proc/acpi/ibm/fan (and if
> 
> See the first mail. I don't touch any fan settings, everything is at
> the default value.
> 
> > possible, the contents of /proc/acpi/ibm/ecdump) before you issue the
> > suspend command.
> 
> See http://tikei.de/ecdump (however, this was taken with 2.6.27.4).

It should not have set the fan to level 7, so it means we will need to add
debugging hints to the driver.  I don't have my T43 with me right now, or I
could try to reproduce the issue.

Are you confortable with adding some printk's to kernel source?  If so, try
to printk the interesting bits in fan_suspend and fan_resume on
drivers/misc/thinkpad_acpi.c.

Otherwise, I can provide you with a patch with the debug printks later.  But
either way, you'd need to recompile your kernel to get the changed
thinkpad-acpi module to test.  I hope that is not a problem?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
