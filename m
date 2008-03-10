Return-Path: <linux-kernel-owner+w=401wt.eu-S1753256AbYCJQVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256AbYCJQVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYCJQVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:21:33 -0400
Received: from gherkin.frus.com ([192.158.254.49]:42549 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbYCJQVc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:21:32 -0400
Subject: Re: [regression] 2.6.25-rc4 snd-es18xx broken on Alpha
In-Reply-To: <47D55115.3010708@keyaccess.nl> "from Rene Herman at Mar 10, 2008
 04:17:41 pm"
To: Rene Herman <rene.herman@keyaccess.nl>
Date: Mon, 10 Mar 2008 11:21:30 -0500 (CDT)
CC: Michael Cree <mcree@orcon.net.nz>, Bob Tracy <rct@frus.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       ALSA devel <alsa-devel@alsa-project.org>
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20080310162130.AFFD3DBA2@gherkin.frus.com>
From: rct@frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> > Bob Tracy wrote:
> 
> >> Supposedly with the ES1888, dma1 is for capture, dma2 is for playback. 
> >> dma2 == 5 is a 16-bit channel, yes?  That could explain much...
> 
> It is, but what would it explain? You're only having playback problems, right?

dma2 is for playback, I'm having playback problems, dma2 == 5 is a
a 16-bit channel, and 16-bit DMA is an issue with the es18xx driver
(according to the comment near the top of the file).

> Can it be forced to use dma2=0 (an 8-bit channel, and the usual capture 
> channel on es18xx)? However, that might not be the issue anyway:

I'll try a few things like dma2 == dma1, and setting dma2 to an 8-bit
channel, but I think the various configuration parameters are hard-wired
on the Alpha (not PnP).

> This sounds very suspiciously like a difference with playing through the 
> native ALSA interface and the OSS emulaion. Could you and/or Bob confirm 
> that sox is using the OSS emulation and not ALSA natively?
> 
> I could very well imagine the ALSA OSS emulation being broken on Alpha. I 
> doubt any of teh developers has an Alpha. And if aplay works correctly this 
> seems very likely.

I'll see if I can verify whether it's a native ALSA vs. OSS emulation
issue.

The local version of sox (Debian 12.7.9-1) contains a library dependency
on libasound.so.2, and a "strings" on the binary yields "ALSA_0.9.0rc4"
as well as several ALSA error message strings.  However, output by
default goes to /dev/dsp (major 14, minor 3), which is definitely OSS.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "I was a beta tester for dirt.  They never did
rct@frus.com       |   get all the bugs out." - Steve McGrew on /.
------------------------------------------------------------------------
