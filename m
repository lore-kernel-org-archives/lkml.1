Return-Path: <linux-kernel-owner+w=401wt.eu-S1753517Ab0ATLAw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753517Ab0ATLAw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 06:00:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450Ab0ATLAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 06:00:50 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:31428 "EHLO
	TX2EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146Ab0ATLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 06:00:49 -0500
X-SpamScore: 2
X-BigFish: VPS2(z1039oz98dNzz1202hzzz32i6bh63h)
X-Spam-TCS-SCL: 2:0
X-WSS-ID: 0KWJL8W-01-RO2-02
X-M-MSG: 
Date: Wed, 20 Jan 2010 12:00:31 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: monstr@monstr.eu, linux-kernel@vger.kernel.org, michal.simek@petalogix.com,
       arnd@arndb.de, linux-arch@vger.kernel.org,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: Generic DMA - BUG_ON
Message-ID: <20100120110031.GD8665@amd.com>
References: <1263982111-24123-1-git-send-email-monstr@monstr.eu>
 <20100120105350.GA23394@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100120105350.GA23394@flint.arm.linux.org.uk>
Organization: Advanced Micro Devices =?iso-8859-1?Q?GmbH?=
	=?iso-8859-1?Q?=2C_Karl-Hammerschmidt-Str=2E_34=2C_85609_Dornach_bei_M=FC?=
	=?iso-8859-1?Q?nchen=2C_Gesch=E4ftsf=FChrer=3A_Thomas_M=2E_McCoy=2C_Giuli?=
	=?iso-8859-1?Q?ano_Meroni=2C_Andrew_Bowd=2C_Sitz=3A_Dornach=2C_Gemeinde_A?=
	=?iso-8859-1?Q?schheim=2C_Landkreis_M=FCnchen=2C_Registergericht_M=FCnche?=
	=?iso-8859-1?Q?n=2C?= HRB Nr. 43632
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 20 Jan 2010 11:00:31.0927 (UTC) FILETIME=[C8BF6470:01CA99BF]
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 10:53:50AM +0000, Russell King wrote:
> and ops is NULL, then this code will oops; you will get a full register
> dump and backtrace.  You can use this information along with markup_oops.pl
> to find out where the problem is.

You can't rely on the oops if the code runs in process context. The
process may have address 0 mapped which would result in a security hole.
We had two of these bugs last year.

But I don't see any point in checking for dma_ops != NULL too. Any
developer would mention such a bug long before init is started.

	Joerg


