Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbXH2Tfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbXH2Tfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 15:35:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbXH2Tfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 15:35:38 -0400
Received: from viefep27-int.chello.at ([62.179.121.47]:55637 "EHLO
	viefep27-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753040AbXH2Tfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 15:35:37 -0400
X-Greylist: delayed 72361 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 15:35:37 EDT
From: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: Linux 2.6.23-rc4: BAD regression
Date: Wed, 29 Aug 2007 21:35:56 +0200
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Len Brown <len.brown@intel.com>, linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <200708290129.57243.daniel.ritz-ml@swissonline.ch> <46D4F905.6080908@suse.de>
In-Reply-To: <46D4F905.6080908@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708292135.57584.daniel.ritz-ml@swissonline.ch>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 August 2007 06:41:41 Alexey Starikovskiy wrote:
> Daniel,
> Does this patch help you, or do we need to revert the whole thing?
> 

yes, this does the trick. the fan goes on again. thanks.
if you still need additional debug output or if you want me to test
a different patch just let me know.

rgds
-daniel

> Sorry for the trouble,
> Alex.
> Daniel Ritz wrote:
> > tried that one on my old toshiba tecra 8000 laptop, almost killing it.
> > the fan doesn't work any more...type 'make' and see the box dying.
> > luckily my CPU doesn't commit suicide...bisected it to that one:
> >
> > cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b is first bad commit
> > commit cd8c93a4e04dce8f00d1ef3a476aac8bd65ae40b
> > Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> > Date:   Fri Aug 3 17:52:48 2007 -0400
> >
> >     ACPI: EC: If ECDT is not found, look up EC in DSDT.
> >
> >     Some ASUS laptops access EC space from device _INI methods, but do not
> >     provide ECDT for early EC setup. In order to make them function properly,
> >     there is a need to find EC is DSDT before any _INI is called.
> >
> >     Similar functionality was turned on by acpi_fake_ecdt=1 command line
> >     before. Now it is on all the time.
> >
> >     http://bugzilla.kernel.org/show_bug.cgi?id=8598
> >
> >     Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
> >     Signed-off-by: Len Brown <len.brown@intel.com>
> >   


