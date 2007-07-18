Return-Path: <linux-kernel-owner+w=401wt.eu-S1758105AbXGRXBQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbXGRXBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:01:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761541AbXGRW7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 18:59:13 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38493 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933786AbXGRW7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 18:59:10 -0400
Date: Wed, 18 Jul 2007 15:57:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-usb-devel@lists.sourceforge.net,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nicolas Boichat <nicolas@boichat.ch>,
       Michael Hanselmann <linux-kernel@hansmi.ch>,
       Peter Osterlund <petero2@telia.com>,
       Frank Arnold <frank@scirocco-5v-turbo.de>,
       Stelian Pop <stelian@popies.net>,
       Johannes Berg <johannes@sipsolutions.net>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [PATCH] appletouch powersaving - please apply for 2.6.23-rc1
Message-Id: <20070718155758.072db90d.akpm@linux-foundation.org>
In-Reply-To: <1184656218.14051.43.camel@localhost>
References: <1184656218.14051.43.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Jul 2007 09:10:18 +0200
Soeren Sonnenburg <kernel@nn7.de> wrote:

> the attached minimally intrusive patch is based on Matthew Garret's
> patch 'Make appletouch shut up when it has nothing to say' patches (e.g.
> http://lkml.org/lkml/2007/5/13/117): Matthews description follows /
> second paragraph lists my additional changes.
> 
> The appletouch geyser3 devices found in the Intel Macs (and possibly some later 
> PPC ones?) send a constant stream of packets after the first touch. This 
> results in the kernel waking up around once every couple of milliseconds 
> to process them, making it almost impossible to spend any significant 
> period of time in C3 state on a dynamic HZ kernel. Sending the mode 
> initialization code makes the device shut up until it's touched again. 
> This patch does so after receiving 10 packets with no interesting 
> content.
> 
> In addition it now empties the work queue via cancel_work_sync on module
> exit, keeps all error checking and only reports BTN_LEFT presses if bit
> 1 in the status byte (last byte in packet) is set. This fixes the random
> left clicks issue. Furthermore it invalidates touchpad data before the
> mode switch, which fixes the touchpad runs amok issue.

Please feed this through scripts/checkpatch.pl and consider addressing
all the things which it reports.
