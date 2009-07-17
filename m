Return-Path: <linux-kernel-owner+w=401wt.eu-S1757774AbZGQFMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757774AbZGQFMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 01:12:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbZGQFMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 01:12:46 -0400
Received: from gate.crashing.org ([63.228.1.57]:38068 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZGQFMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 01:12:45 -0400
Subject: Re: [PATCH 1/2] vga: implements VGA arbitration on Linux
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Airlie <airlied@redhat.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Tiago Vignatti <tiago.vignatti@nokia.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1247806842.3572.12.camel@clockmaker.usersys.redhat.com>
References: <1247576250-16274-1-git-send-email-tiago.vignatti@nokia.com>
	 <1247576250-16274-2-git-send-email-tiago.vignatti@nokia.com>
	 <20090714153509.51bbec27@lxorguk.ukuu.org.uk>
	 <1247806842.3572.12.camel@clockmaker.usersys.redhat.com>
Content-Type: text/plain
Date: Fri, 17 Jul 2009 15:12:15 +1000
Message-Id: <1247807535.6101.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-17 at 15:00 +1000, Dave Airlie wrote:
> 
> device doesn't decode VGA: normal io/mem locks always pass, legact
> io/mem locks always fail. don't touch main lock
> 
> device decodes VGA: (acts like read/write lock)

Well, my initial idea was that even if you are marked as not decoding
legacy, you could still lock it.

The idea here is that if I'm going to just run a quick BIOS routine, ie
temporarily turn on legacy decoding and back off, I can just lock it, do
that, and unlock it.

No need to globally switch yourself to be a legacy decoder globally for
the arbiter (ie, you lock it so you can't lose it, and you'll have
re-disabled legacy decoding by the time you unlock, so there's no need
in getting notified of loss etc....

But you don't have to support that behaviour :-) I just thought it could
come handy.

> asks for normal mem/io locks: if no locks or only other normal locks
> are
> held by devices that decode VGA, then take main lock as a reader and
> enable decodes. If someone holds lock as a write block waiting for it.
> 
> asks for VGA mem/io locks, if no locks are held, take main lock as a
> writer. If main lock has readers already, block waiting for a write
> lock
> on it.
> 
> Does this sound sane?

Cursory glance it does.

Cheers,
Ben.

> Dave.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

