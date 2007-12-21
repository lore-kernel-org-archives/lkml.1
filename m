Return-Path: <linux-kernel-owner+w=401wt.eu-S1758765AbXLUOn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765AbXLUOn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 09:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036AbXLUOnV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 09:43:21 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:57328 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751000AbXLUOnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 09:43:20 -0500
Date: Fri, 21 Dec 2007 09:43:19 -0500
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
Message-ID: <20071221144319.GH2308@csclub.uwaterloo.ca>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com> <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com> <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com> <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2007 at 04:27:37PM -0500, linux-os (Dick Johnson) wrote:
> I need to get rid of -mregparm=3 on gcc's command line. It
> is completely incompatible with the standard calling conventions
> used in all our assembly-language files in our drivers. We make
> very high-speed number-crunching drivers that munge high-speed
> data into images. We need to do that in assembly as we have
> always done.

Well I guess you can either fix the assembly once and for all to handle
the current linux way of doing things, or you can patch to kernel back
to the old ways of doing things when using your driver.

I suppose you could just add some wrapper functions to your assembly
that uses the new regparm calling method and then calls your methods the
old way and selectively enable those when regparm is used by the kernel
if you want to support all kernel versions.  Or you could use inline
assembly in C functions to handle the calling convention for you.

--
Len Sorensen
