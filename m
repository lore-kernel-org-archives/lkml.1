Return-Path: <linux-kernel-owner+w=401wt.eu-S1760258AbYDCSed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760258AbYDCSed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 14:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756177AbYDCSeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 14:34:15 -0400
Received: from emh04.mail.saunalahti.fi ([62.142.5.110]:37219 "EHLO
	emh04.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755902AbYDCSeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 14:34:13 -0400
Date: Thu, 3 Apr 2008 21:34:09 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Robert Hancock <hancockr@shaw.ca>
cc: Carlo Nyto <carlonyto@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Slow tape drive timeout
In-Reply-To: <47F45B39.7080305@shaw.ca>
Message-ID: <alpine.LSU.1.10.0804032121380.9918@kai.makisara.local>
References: <fa.iY7vJs54MoScDgyQ4PUWZsO+3Jw@ifi.uio.no> <fa.of3hIrxfNefAS08Tzqfm1dI0BOo@ifi.uio.no> <47F45B39.7080305@shaw.ca>
User-Agent: Alpine 1.10 (LSU 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Robert Hancock wrote:

> Kai Makisara wrote:
> > On Tue, 1 Apr 2008, Carlo Nyto wrote:
> > 
> > > I am experiencing a two minute timeout open()ing a tape device when
> > > there is no tape in the drive.
> > > 
> > > open() with O_NONBLOCK succeeds immediately, however.
> > > 
> > This is how open() is supposed to work according to standards (e.g., SUS) if
> > O_NONBLOCK is supported. (Well, actually open() should wait indefinitely but
> > the non-linux systems I tested had a timeout.) The linux st driver was
> > changed to comply with standards at 2.5.3. I.e., the 2.4 kernels did return
> > immediately but the 2.6 kernels have always waited.
> > 
...
> Why is accessing the tape drive with no tape in it causing a timeout in the
> first place? I should think that would fail immediately with some "medium not
> present" error from the drive. Unless the drive has no mechanism to detect it,
> but that seems really retarded..
> 
It does not seem retarded to me. If a program wants to just wait until the 
tape drive becomes ready (e.g., loads the tape), it can use the blocking 
open. This is simple. If a program wants to test the status, it uses 
non-blocking open. The behavior mandated by the standards provides 
alternatives. If O_NONBLOCK is not supported, the user program must 
implement the waiting logic if the program just wants to wait until the 
drive is ready before starting i/o.

-- 
Kai
