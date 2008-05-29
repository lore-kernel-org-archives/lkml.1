Return-Path: <linux-kernel-owner+w=401wt.eu-S1757925AbYE2SoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925AbYE2SoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751468AbYE2SoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 14:44:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53244 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbYE2SoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 14:44:02 -0400
Message-ID: <483EF94F.7040403@zytor.com>
Date: Thu, 29 May 2008 11:43:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Honor 'quiet' command line option in real mode boot
 decompressor.
References: <1212082032-6167-1-git-send-email-krh@redhat.com> <1212082032-6167-2-git-send-email-krh@redhat.com>
In-Reply-To: <1212082032-6167-2-git-send-email-krh@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> This patch lets the early real mode decompressor parse the kernel
> command line and look for the 'quiet' option.  When 'quiet' is passed
> we suppress the "Decompressing Linux... Parsing ELF... done." messages.
> 
> This is in line with how the rest of the kernel suppresses informational
> debug spew when quiet is given.
> 
> Signed-off-by: Kristian HÃ¸gsberg <krh@redhat.com>

You know... we already have a command-line parser in the real-mode part 
of the boot code, and it already extracts the "quiet" option: we should 
be able to do this by passing a bit in "loadflags" (bit 5 suggested.) 
This would have the additional benefit of making it really easy for 
hypervisors that don't support writing to the screen at all to disable 
those messages.

What do you think?

	-hpa
