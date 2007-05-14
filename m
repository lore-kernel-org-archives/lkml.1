Return-Path: <linux-kernel-owner+w=401wt.eu-S1761190AbXENU2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761190AbXENU2w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 16:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758888AbXENU2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 16:28:43 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:49175
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756515AbXENU2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 16:28:42 -0400
From: Rob Landley <rob@landley.net>
To: Dave Jones <davej@redhat.com>
Subject: Re: tracking down disk spinups.
Date: Mon, 14 May 2007 16:28:35 -0400
User-Agent: KMail/1.9.1
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070514185734.GM27604@redhat.com>
In-Reply-To: <20070514185734.GM27604@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705141628.35617.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 May 2007 2:57 pm, Dave Jones wrote:
> Why did the kernel ignore what I told it to do ?
> I'm sure it thinks it knows better than me for a reason, but
> I'd like to know what it is.

Remount doesn't switch filesystem drivers, it tells the existing filesystem 
driver to accept new flags and/or a new option string.

To switch drivers you have to umount the old sucker and mount the new one.  
(The idea of handing off consistent cache data from one mounted filesystem 
driver to another...  Ouch.)

Most filesystem drivers aren't compatible with each other anyway.  Sounds like 
what you really want to do is put the ext3 driver into "ext2 mode", and stop 
journaling.  Many people have wanted this over the years, but alas our dream 
of "one darn driver for the ext# family" got squashed years ago because 
people wanted two different codebases for the same filesystem that could 
diverge, require the same bugs to be fixed twice, become incompatible...

Rob
