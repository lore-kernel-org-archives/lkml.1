Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494AbZIJTVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494AbZIJTVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 15:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbZIJTVD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 15:21:03 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46005 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134AbZIJTVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 15:21:02 -0400
Message-ID: <4AA950C8.1080200@zytor.com>
Date: Thu, 10 Sep 2009 12:17:28 -0700
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
References: <20090908144942.76ddf0e7@caramujo.chehab.org>	<4AA6DF50.3030603@zytor.com>	<20090908203323.486c129c@caramujo.chehab.org>	<4AA6F63F.7090009@zytor.com>	<20090908235441.04549a29@caramujo.chehab.org>	<4AA73309.8030302@zytor.com>	<20090910010512.60a1f523@caramujo.chehab.org>	<4AA89B02.1050909@zytor.com>	<20090910093301.4ccfd786@caramujo.chehab.org>	<20090910150716.66310f02@lxorguk.ukuu.org.uk>	<4AA92487.5080401@zytor.com> <20090910161215.5129bd71@caramujo.chehab.org>
In-Reply-To: <20090910161215.5129bd71@caramujo.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2009 12:12 PM, Mauro Carvalho Chehab wrote:
> 
> +1. Reusing the namespace after tty[p-za-e][0-9a-f] doesn't seem to be good, IMHO.
> 

I think it's better to extend the strings with the current prefixes than
to burn the virgin ttyf* prefix.

> In the case of the BSD sockets, the patch is not just an userless fix. This is
> interesting when some applications are ported from other Unix'es and still uses BSD
> pty's, since several other Unix flavors were defining a higher namespace size.
> 
> For example, on zOS Unix, a pty device seems to allow up to 10.000 pty numbers (in the
> specific case of zOS Unix, they seem to be defined as /dev/[pt]typ[0-9]...) as shown at:
> 	www.redbooks.ibm.com/redbooks/pdfs/sg245228.pdf
> 

Yes, but you have to port the application *anyway* do deal with the
namespace.  BSD tty allocation is done largely by each application,
which makes it even worse.  Furthermore, there is the static allocation
issue, so unless there is a concrete application which needs this *and*
cannot be ported to Unix98 ptys (which is the Right Thing[TM] to do) I
think Alan is right.

	-hpa
