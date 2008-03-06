Return-Path: <linux-kernel-owner+w=401wt.eu-S1762387AbYCFPQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762387AbYCFPQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 10:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760306AbYCFPQd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 10:16:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56525 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758052AbYCFPQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 10:16:32 -0500
Message-ID: <47D00AC0.8010805@zytor.com>
Date: Thu, 06 Mar 2008 07:16:16 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-boot: don't request VBE2 information
References: <1204797405-18059-1-git-send-email-jacmet@sunsite.dk>
In-Reply-To: <1204797405-18059-1-git-send-email-jacmet@sunsite.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Korsgaard wrote:
> The new x86 setup code (4fd06960f120) broke booting on an old P3/500MHz
> with an onboard Voodoo3 of mine. After debugging it, it turned out
> to be caused by the fact that the vesa probing now asks for VBE2 data.
> 
> Disassembing the video BIOS shows that it overflows the vesa_general_info
> structure when VBE2 data is requested because the source addresses for the
> information strings which get strcpy'ed to the buffer lie outside the 32K
> BIOS code (and hence contain long sequences of 0xff's).
> 

I'm slightly concerned about this, because we *do* use VBE2 data - just 
not the stuff that this particular BIOS seems to key on (and break.)

On the other hand, until we get an example on something that breaks with 
the change, we might as well try it, since we have an example on 
something that breaks with it.  We should monitor carefully, though.

	-hpa
