Return-Path: <linux-kernel-owner+w=401wt.eu-S1762057AbZLJWpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762057AbZLJWpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 17:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762048AbZLJWpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 17:45:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57145 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762021AbZLJWpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 17:45:47 -0500
Message-ID: <4B2179E7.6030009@zytor.com>
Date: Thu, 10 Dec 2009 14:44:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Roland Dreier <rdreier@cisco.com>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression
References: <20091210091040.GG8742@kernel.dk>	<20091210103945.GI8742@kernel.dk> <20091210160640.GB27794@elte.hu>	<67EA4830-231F-45C9-A1A6-CE1C6CD9493D@kernel.org>	<20091210180727.GK8742@kernel.dk> <4B213F1F.2020305@kernel.org>	<4B2140F8.3020201@kernel.org> <20091210184506.GP8742@kernel.dk>	<20091210190742.GS8742@kernel.dk> <4B2149B4.9060900@kernel.org>	<adaaaxqmxvs.fsf@roland-alpha.cisco.com> <4B214D00.90908@kernel.org> <ada1vj2mxj6.fsf@roland-alpha.cisco.com> <4B21510D.4030609@kernel.org>
In-Reply-To: <4B21510D.4030609@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2009 11:50 AM, Yinghai Lu wrote:
> Roland Dreier wrote:
>>  > that BIOS is using first 64k for mptable. and after booting those
>>  > mptable is overwritten by trampoline.
>>
>> So fix that BIOS people should do is to move the mptable above 64K and
>> leave low 64K empty?
> 
> Yes. should be below and near 1M, and use e820 to reserve it.
> 

Keep in mind BIOS loads and runs the OS bootloader at 0x7c00.  If this
is a conventional BIOS, there is absolutely no way such a table is
intact by the time the OS runs.

The BIOS should, indeed put it either in the UMA (0xc800..0xffff) or at
the top of DOS memory (just below 640K) and reserve it in e820.
Anything else is irreparably broken.

	-hpa

