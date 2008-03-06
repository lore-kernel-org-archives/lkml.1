Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYCFIoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYCFIoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbYCFIoL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:44:11 -0500
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:8484 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402AbYCFIoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:44:09 -0500
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Richard Guenther <richard.guenther@gmail.com>,
       Joe Buck <Joe.Buck@synopsys.com>, Michael Matz <matz@suse.de>,
       Jan Hubicka <hubicka@ucw.cz>, Aurelien Jarno <aurelien@aurel32.net>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt direction  flag
References: <20080305153020.GA24631@volta.aurel32.net>
	<47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com>
	<20080305202319.GA17053@volta.aurel32.net>
	<Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
	<20080305204234.GB17267@synopsys.com>
	<20080305204945.GB14011@atrey.karlin.mff.cuni.cz>
	<Pine.LNX.4.64.0803052158270.20583@wotan.suse.de>
	<20080305212005.GC17267@synopsys.com>
	<84fc9c000803051332q2f2eedeej7d3c0509e698cabf@mail.gmail.com>
	<47CF11D6.7070901@zytor.com>
From: Andi Kleen <andi@firstfloor.org>
Date: 06 Mar 2008 09:44:05 +0100
In-Reply-To: <47CF11D6.7070901@zytor.com>
Message-ID: <87ablcgs2y.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 06 Mar 2008 08:37:36.0001 (UTC) FILETIME=[54222F10:01C87F65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Richard Guenther wrote:
> > We didn't yet run into this issue and build openSUSE with 4.3 since
> > more than
> > three month.
> >
> 
> Well, how often do you take a trap inside an overlapping memmove()?

That was the state with older gcc, but with newer gcc it does not necessarily
reset the flag before the next function call.

so e.g. if you have

        memmove(...)
        for (... very long loop .... ) {
                /* no function calls */
                /* signals happen */
        }

the signal could see the direction flag

-Andi
