Return-Path: <linux-kernel-owner+w=401wt.eu-S1760020AbYCEQFs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760020AbYCEQFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 11:05:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756096AbYCEQFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 11:05:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43756 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173AbYCEQFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 11:05:10 -0500
Message-ID: <47CEC3AA.6080709@zytor.com>
Date: Wed, 05 Mar 2008 08:00:42 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Aurelien Jarno <aurelien@aurel32.net>, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: Linux doesn't follow x86/x86-64 ABI wrt direction flag
References: <20080305153020.GA24631@volta.aurel32.net>
In-Reply-To: <20080305153020.GA24631@volta.aurel32.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aurelien Jarno wrote:
> Hi all,
> 
> Since version 4.3, gcc changed its behaviour concerning the x86/x86-64 
> ABI and the direction flag, that is it now assumes that the direction 
> flag is cleared at the entry of a function and it doesn't clear once 
> more if needed.
> 
> This causes some problems with the Linux kernel which does not clear
> the direction flag when entering a signal handler. The small code below
> (for x86-64) demonstrates that. 
> 
> If the signal handler is using code that need the direction flag cleared
> (for example bzero() or memset()), the code is incorrectly executed.
> 
> I guess this has to be fixed on the kernel side, but also gcc-4.3 could
> revert back to the old behaviour, that is clearing the direction flag
> when entering a routine that touches it until most people are running a
> fixed kernel.
> 

Linux should definitely follow the ABI.  This is a bug, and a pretty 
serious such.

	-hpa
