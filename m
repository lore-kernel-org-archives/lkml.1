Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZIJX3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZIJX3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 19:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZIJX3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 19:29:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57858 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZIJX3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 19:29:44 -0400
Message-ID: <4AA98AF8.7050701@zytor.com>
Date: Thu, 10 Sep 2009 16:25:44 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Mauro Carvalho Chehab <mchehab@infradead.org>,
       Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com>	<20090910010512.60a1f523@caramujo.chehab.org>	<4AA89B02.1050909@zytor.com>	<20090910093301.4ccfd786@caramujo.chehab.org>	<20090910150716.66310f02@lxorguk.ukuu.org.uk>	<4AA92487.5080401@zytor.com>	<20090910161215.5129bd71@caramujo.chehab.org> <20090911002329.07d60484@lxorguk.ukuu.org.uk>
In-Reply-To: <20090911002329.07d60484@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 04:23 PM, Alan Cox wrote:
> 
> They won't work because the glibc pty name handling only does the 256
> devices. Given glibc still hasn't picked up tty changes from several
> years ago I doubt it'll ever pick up a naming change.
> 
> BSD pty is dead. It has all sorts of problems including time taken to
> find a new port being dependant on ports currently in use. The amount of
> code that cares about it is close to nil, that which cares about it uses
> glibc BSD pty helper code so won't work with > 256 anyway.
> 

I don't think they use glibc helper code, or they would automatically
end up with Unix98 ptys.  Rather, the remaining users of BSD ptys are
probably those where the application hard-codes the pty naming for each
platform it ran on... which is even worse of a compatibility nightmare,
of course.

	-hpa

