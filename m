Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYKYTrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYKYTrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 14:47:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbYKYTrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 14:47:12 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:63887 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYKYTrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 14:47:10 -0500
X-Greylist: delayed 760 seconds by postgrey-1.27 at vger.kernel.org; Tue, 25 Nov 2008 14:47:10 EST
Message-ID: <492C562E.9090302@oracle.com>
Date: Tue, 25 Nov 2008 11:46:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [BUILD_FAILURE] linux-next: 20081125 - 8390 network driver build
 fails
References: <20081125213738.881b425e.sfr@canb.auug.org.au>	<20081125182542.GA4914@linux.vnet.ibm.com>	<492C464D.4080704@oracle.com>	<20081125185154.2845e8f1@lxorguk.ukuu.org.uk>	<492C5334.2090801@oracle.com> <20081125193853.076c7b58@lxorguk.ukuu.org.uk>
In-Reply-To: <20081125193853.076c7b58@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt704.oracle.com [141.146.40.82]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.492C562C.0145:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>> The problem is that both 8390.c and 8390p.c #include lib8390.c
>> and when they are both linked to built-in drivers (not loadable
>> modules), the symbols in lib8390.c are duplicated.  I think.
> 
> And the symbols in question are static so are scoped within the file
> only. Thats why it looks to me as if someone has done "#define static" in
> another patch somewhere in -next.

Try again:

  LD      drivers/net/built-in.o
drivers/net/8390p.o: In function `ei_get_stats':
(.text+0x1050): multiple definition of `ei_get_stats'
drivers/net/8390.o:(.text+0xe20): first defined here
drivers/net/8390p.o: In function `ei_start_xmit':
(.text+0x1100): multiple definition of `ei_start_xmit'
drivers/net/8390.o:(.text+0xef0): first defined here
drivers/net/8390p.o: In function `ei_tx_timeout':
(.text+0xec0): multiple definition of `ei_tx_timeout'
drivers/net/8390.o:(.text+0xce0): first defined here
drivers/net/8390p.o: In function `ei_set_multicast_list':
(.text+0x1000): multiple definition of `ei_set_multicast_list'
drivers/net/8390.o:(.text+0xea0): first defined here
make[2]: *** [drivers/net/built-in.o] Error 1

and none of these functions is static in lib8390.c.

~Randy
