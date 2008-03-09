Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYCIX6i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYCIX6i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 19:58:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbYCIX6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 19:58:06 -0400
Received: from gherkin.frus.com ([192.158.254.49]:36497 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbYCIX6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 19:58:01 -0400
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <20080309153425.GA1391@jurassic.park.msu.ru> "from Ivan Kokshaysky
 at Mar 9, 2008 06:34:25 pm"
To: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Date: Sun, 9 Mar 2008 18:57:59 -0500 (CDT)
CC: Bob Tracy <rct@frus.com>, linux-kernel@vger.kernel.org,
       linux-alpha@vger.kernel.org
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080309235800.17D26DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ivan Kokshaysky wrote:
> Sounds like a DMA screwup.

Agreed.  There's a comment line near the top of the es18xx.c that has
been there for a *long* time:

	Support for 16 bit DMA seems to be broken. I've no hardware
	to tune it.

Supposedly with the ES1888, dma1 is for capture, dma2 is for playback.
dma2 == 5 is a 16-bit channel, yes?  That could explain much...

As for the values "chosen" for dma1 and dma2, they are the ones that
keep showing up in the Alpha sound "howto" postings/documents.  The
driver can cope with dma1 == dma2 by enforcing half-duplex mode in
software, but the OSS "sb" driver works fine with the indicated DMA
channel values.  Besides, if the ES1888 is really capable of full-duplex
operation, a potential half-duplex workaround doesn't have much appeal.

> I wonder if it still works on x86 - perhaps you ought to ask ALSA folks.

I tried contacting the driver authors as indicated in the driver source
file.  Christian Fischbach seems to have disappeared.  Still waiting to
hear from Abramo Bagnara.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
