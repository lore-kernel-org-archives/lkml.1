Return-Path: <linux-kernel-owner+w=401wt.eu-S1762860AbZJOQFP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762860AbZJOQFP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 12:05:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762228AbZJOQFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 12:05:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757636AbZJOQFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 12:05:13 -0400
Date: Thu, 15 Oct 2009 09:04:09 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Oleg Nesterov <oleg@redhat.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Paul Fulghum <paulkf@microgate.com>,
       Boyan <btanastasov@yahoo.co.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: Re: [Bug #14388] keyboard under X with 2.6.31
In-Reply-To: <20091015152959.GA18681@redhat.com>
Message-ID: <alpine.LFD.2.01.0910150901190.6146@localhost.localdomain>
References: <4AD51D6B.7010509@microgate.com> <alpine.LFD.2.01.0910131744590.3404@localhost.localdomain> <20091014125846.1a3c8d40@lxorguk.ukuu.org.uk> <alpine.LFD.2.01.0910140804180.6146@localhost.localdomain> <alpine.LFD.2.01.0910140925440.6146@localhost.localdomain>
 <20091014182037.GA10076@redhat.com> <alpine.LFD.2.01.0910141131050.6146@localhost.localdomain> <20091014195215.GA12936@redhat.com> <alpine.LFD.2.01.0910141344250.6146@localhost.localdomain> <20091015124730.GA9398@redhat.com>
 <20091015152959.GA18681@redhat.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 15 Oct 2009, Oleg Nesterov wrote:
> 
> Actually, this looks simple. Please see the patch below.

Ok, I should have read all my emails before responding to the previous 
one.

But my response ends up being the same: I think your patch is fine, and I 
think you should drop the conditional flag. I don't think anybody _ever_ 
wants to run the same work entry on multiple CPU's at once. Anybody who 
wants parallelism needs to use multiple work entries _anyway_ (since the 
accidental parallelism you *can* get with a single one is really very 
accidental indeed).

Of course, it should be tested in -next for a while regardless. And talk 
to the networkng people, who are the main user of workqueues.

			Linus
