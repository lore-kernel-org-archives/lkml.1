Return-Path: <linux-kernel-owner+w=401wt.eu-S1754199AbZIJUjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbZIJUjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754153AbZIJUjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:39:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36592 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753239AbZIJUja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:39:30 -0400
Message-ID: <4AA96328.1040809@zytor.com>
Date: Thu, 10 Sep 2009 13:35:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH] char/tty_io: fix legacy pty name when more than 256 pty
 devices are requested
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com>	<20090910010512.60a1f523@caramujo.chehab.org>	<4AA89B02.1050909@zytor.com>	<20090910093301.4ccfd786@caramujo.chehab.org>	<20090910150716.66310f02@lxorguk.ukuu.org.uk>	<4AA92487.5080401@zytor.com>	<20090910161215.5129bd71@caramujo.chehab.org>	<4AA950C8.1080200@zytor.com> <20090910170538.3df10839@caramujo.chehab.org>
In-Reply-To: <20090910170538.3df10839@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 01:05 PM, Mauro Carvalho Chehab wrote:
>>
>> Yes, but you have to port the application *anyway* do deal with the
>> namespace.
> 
> Or create some udev rules for that.
> 

udev rules does zero good, because the way the BSD ptys go, the
application itself needs to understand what the naming scheme is.  So it
is an application-by-application slog.

>> BSD tty allocation is done largely by each application,
>> which makes it even worse.  Furthermore, there is the static allocation
>> issue, so unless there is a concrete application which needs this *and*
>> cannot be ported to Unix98 ptys (which is the Right Thing[TM] to do) I
>> think Alan is right.
> 
> The amount of static allocation space can be controlled via pty.legacy_count
> boot parameter. It overrides whatever specified at CONFIG_LEGACY_PTY_COUNT.
> You can even let LEGACY_PTY_COUNT = 0 and enable the actual numbers of needed
> legacy ptys via boot parameter, where needed. So, this is not a problem on a
> real situation.

It still means you are statically allocating a fixed number at boot time.

	-hpa

