Return-Path: <linux-kernel-owner+w=401wt.eu-S2992522AbXDLNK3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992522AbXDLNK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 09:10:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992524AbXDLNK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 09:10:29 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45242 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992522AbXDLNK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 09:10:28 -0400
Date: Thu, 12 Apr 2007 14:13:06 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Egmont Koblinger <egmont@uhulinux.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Pavel Machek <pavel@ucw.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412141306.0c1b6820@the-village.bc.nu>
In-Reply-To: <20070412125412.GA729@uhulinux.hu>
References: <20070407092451.GA8779@uhulinux.hu>
	<Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
	<20070407172603.GA25351@uhulinux.hu>
	<4617DBF7.5060009@zytor.com>
	<20070410094325.GB9143@uhulinux.hu>
	<461BB092.3070201@zytor.com>
	<20070410171924.GA18314@uhulinux.hu>
	<20070410183659.7341eeec@the-village.bc.nu>
	<20070411182801.GC26382@uhulinux.hu>
	<461D2AB8.5080902@zytor.com>
	<20070412125412.GA729@uhulinux.hu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> So please accept these hard-coded tables in the first round. Maybe one day
> somebody will come up with a better solution. This one should be okay until
> then. (I can also send the script I've written so he can improve it.)

You can pack them a little differently and they'll shrink a lot.

Firstly store
		start, size

Secondly pack the offset as 16 bit with the top 4 bits

		0-3 value
		4 - F
		5 - 1D
		6 - E0

And the size as an 8 bit range. You need to open code the rule for 
20000/30000 but that is tiny anyway.

Unpack is trivial

	start = (toptab[*entry>>4]|(*entry&0x0F)) << 8 | entry[1];
	end = start + entry[2];

