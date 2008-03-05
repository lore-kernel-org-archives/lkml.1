Return-Path: <linux-kernel-owner+w=401wt.eu-S1757679AbYCEUsd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757679AbYCEUsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 15:48:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753123AbYCEUsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 15:48:25 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57539 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752380AbYCEUsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 15:48:25 -0500
Message-ID: <47CF0627.2070200@zytor.com>
Date: Wed, 05 Mar 2008 12:44:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Michael Matz <matz@suse.de>
CC: Aurelien Jarno <aurelien@aurel32.net>, Joe Buck <Joe.Buck@synopsys.COM>,
       linux-kernel@vger.kernel.org, gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net> <47CEC3AA.6080709@zytor.com> <20080305195834.GA17267@synopsys.com> <20080305202319.GA17053@volta.aurel32.net> <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
In-Reply-To: <Pine.LNX.4.64.0803052133400.20583@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Matz wrote:
> Hi,
> 
> On Wed, 5 Mar 2008, Aurelien Jarno wrote:
> 
>>> So I think gcc at least needs an *option* to revert to the old behavior,
>>> and there's a good argument to make it the default for now, at least for
>>> x86/x86-64 on Linux.
>> And for other kernels. I tested OpenBSD 4.1, FreeBSD 6.3, NetBSD 4.0, 
>> they have the same behaviour as Linux, that is they don't clear DF 
>> before calling the signal handler.
> 
> Sigh.  We could perhaps insert a cld for all functions which can be 
> recognized as possible signal handlers and call other unknown or string 
> functions.  But it's probably even faster to emit cld in front of the 
> inline copies of mem functions again :-(
> 

Well, there is a (slight) difference: you know that a called function 
will not clobber your DF state; it's only the entry condition which is 
imprecise.

The best would be if this could be controlled by a flag, which we can 
flip once kernel fixes has been around for long enough.

	-hpa
