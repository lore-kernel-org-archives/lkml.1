Return-Path: <linux-kernel-owner+w=401wt.eu-S1765759AbXKPM5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765759AbXKPM5K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 07:57:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbXKPM46
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 07:56:58 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:50050 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106AbXKPM45 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 07:56:57 -0500
Date: Fri, 16 Nov 2007 13:58:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andreas Herrmann <aherrman@arcor.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kconfig: ARCH=x86
Message-ID: <20071116125835.GA31029@uranus.ravnborg.org>
References: <20071116111446.GA16968@devil>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071116111446.GA16968@devil>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andreas.

On Fri, Nov 16, 2007 at 12:14:46PM +0100, Andreas Herrmann wrote:
> Hi,
> 
> I have just some minor remarks wrt the commit message for
> daa93fab824f2b8c35bd11670c7fab2f32b2de5f - 'x86: enable "make
> ARCH=x86"'. (Based on my observations when testing the stuff on 64bit
> and 32bit hosts with Linus' tree v2.6.24-rc2-640-g8c08634.)
> 
> For randconfig we have now the following behaviour.  (The table shows
> whether the resulting configuration is for 32 or 64-bit.)
> 
> # make randconfig [ARCH=...] [K64BIT=]
> 
> option \ host arch      | 32bit         | 64bit
> =====================================================
> ./.                     | 32bit         | 64bit
> ARCH=x86                | 32bit/64bit   | 32bit/64bit
> ARCH=x86 K64BIT=n       | 32bit         | 32bit
> ARCH=x86 K64BIT=y       | 64bit         | 64bit
> ARCH=x86_64             | 64bit         | 64bit
> ARCH=x86_64 K64BIT=n    | 32bit         | 32bit
> ARCH=x86_64 K64BIT=y    | 64bit         | 64bit

To make the table complete you need to consider
make ARCH=i386

Basically is goes like this:
With x86 the default is 32 bit but can be set to 64-bit with K64BIT=y
With x86_64 the default is 64-bit but K64BIT take precedence
With i386 the default is 32 bit but K64BIT takes precedence


All that said I am going to revert the K64BIT possibility.
Roman posted a patch earlier that allows us to based on ARCH setting
select between 32-bit or 64-bit based on ARCH= alone.

	Sam
