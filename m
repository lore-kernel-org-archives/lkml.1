Return-Path: <linux-kernel-owner+w=401wt.eu-S1752036AbXA2Ret@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbXA2Ret (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 12:34:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbXA2Ret
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 12:34:49 -0500
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:45175 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752036AbXA2Res (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 12:34:48 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 29 Jan 2007 12:34:48 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=Received:X-YMail-OSG:Message-ID:Date:From:Reply-To:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=0L7Yysm/1rGvkPr1B1w3Q0ccu580/XcOPBd20awO0lEJAap4+zNWJ+1B8MQ7gv6QW7RI7b6cncSAQ3sRyBBIPbiInQUtCI2U4WyLH+q72Rj+NBjX4VvTCZ6Hdr+lgmDpDs2+QK0tatBPUO8AmAQsCauEPxGeIhivRHcopFIzpNo=  ;
X-YMail-OSG: Zi8QDRgVM1k4xFdwDKCIv7A9wPcDldfLBivGgxuMoVYgcK0b8qJT8np1vH8BEulWNp2v5RjQMF_otI4Dhxd16cZvzui1Rix8DgKSTcb5cnYwuNDyWauPFlChfcRsyZxYflaC1Xehw4MIHw--
Message-ID: <45BE2ECD.2000901@sbcglobal.net>
Date: Mon, 29 Jan 2007 11:28:45 -0600
From: Matthew Frost <artusemrys@sbcglobal.net>
Reply-To: artusemrys@sbcglobal.net
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm2 - modules_install error
References: <20070129001207.71ea3470.akpm@osdl.org>
In-Reply-To: <20070129001207.71ea3470.akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have a consistent problem running 'make modules_install' after compiling.  The
directory structure forms in /lib/modules, but no modules install.  This problem
showed up under -rc6-mm1 and -rc6-mm2, but not -rc6.  I'm hoping somebody has
hit this before, otherwise it's git-bisect time.

Process is what I have been given to understand as proper: untar, patch,
configure and make as $USER, make modules_install as root.  I'm on a new
Slackware-11.0 install (glibc 2.3.6, gcc 3.4.6, module-init-tools 3.2.2),
running linux-2.6.20-rc6.  'make' runs fine, no errors that I can tell.

The output of 'make modules_install' goes something like this:
(... sequence of same for all modules ...)
  INSTALL sound/core/snd-page-alloc.ko
cp: cannot stat `sound/core/snd-page-alloc.ko': No such file or directory
  INSTALL sound/core/seq/snd-seq.ko
cp: cannot stat `sound/core/seq/snd-seq.ko': No such file or directory
  INSTALL sound/core/snd-rtctimer.ko
cp: cannot stat `sound/core/snd-rtctimer.ko': No such file or directory
  INSTALL sound/core/snd-timer.ko
cp: cannot stat `sound/core/snd-timer.ko': No such file or directory
  INSTALL sound/drivers/snd-virmidi.ko
cp: cannot stat `sound/drivers/snd-virmidi.ko': No such file or directory
  INSTALL sound/pci/ac97/snd-ac97-codec.ko
cp: cannot stat `sound/pci/ac97/snd-ac97-codec.ko': No such file or directory
  INSTALL sound/core/snd.ko
cp: cannot stat `sound/core/snd.ko': No such file or directory
  INSTALL sound/drivers/snd-dummy.ko
cp: cannot stat `sound/drivers/snd-dummy.ko': No such file or directory
  INSTALL sound/pci/hda/snd-hda-codec.ko
cp: cannot stat `sound/pci/hda/snd-hda-codec.ko': No such file or directory
  INSTALL sound/pci/hda/snd-hda-intel.ko
cp: cannot stat `sound/pci/hda/snd-hda-intel.ko': No such file or directory
  INSTALL sound/pci/snd-intel8x0.ko
cp: cannot stat `sound/pci/snd-intel8x0.ko': No such file or directory
  INSTALL sound/soundcore.ko
cp: cannot stat `sound/soundcore.ko': No such file or directory
if [ -r System.map -a -x /sbin/depmod ]; then /sbin/depmod -ae -F System.map
2.6.20-rc6-mm2; fi

I have retrieved clean files to make clean trees, and that's not it.  I've tried
making everything as root, and that's not it.  I'm going to keep trying, but
hopefully someone already knows and can tell me what I'm doing wrong or why this
keeps failing.

Thanks!
Matt Frost
