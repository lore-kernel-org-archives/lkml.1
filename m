Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbXGQLTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbXGQLTn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 07:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXGQLTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 07:19:36 -0400
Received: from mx02.hansenet.de ([213.191.73.26]:34597 "EHLO
	webmail.hansenet.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755032AbXGQLTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 07:19:35 -0400
Message-ID: <469CA5B4.5080106@e-dict.net>
Date: Tue, 17 Jul 2007 13:19:16 +0200
From: Ingo Freund <linux-kernel-news@e-dict.net>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: howto create partitions bigger than 2TB
References: <4697760E.4070803@e-dict.net> <46980232.4080500@zytor.com>
In-Reply-To: <46980232.4080500@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.07.2007 00:52, H. Peter Anvin wrote (please find the answer below the original text):
> Ingo Freund wrote:
>> Hi
>>
>> I've got a RAID5 (driver aacraid for an ICP9047MA) with four
>> 750GB hdds which provides a 2.25TB sized device.
>> None of the until now used tools will work with that device.
>> fdisk complains about missing cylinder count.
>> cfdisk misses the device size.
>> parted shows the right device size but only creates a partion
>> with 51GB.
>> What am I supposed to do to work with this device?
>> Which fs can handle it?
>> (CONFIG LARGE BLOCK is on)
>> We are talking about a 32Bit machine with vanilla kernel 2.6.21.5.
>>
> 
> You have to use GPT partitions instead of DOS partitions (although you
> may have to leave your /boot as an DOS partitions, this is supposed to
> be possible as the two partitioning schemes are designed to coexist, but
> I don't think parted has support for it yet.)
> 

This is the solution (for use as a data container on a backup machine):

parted /dev/sdb:
(parted) mklabel gpt
(parted) mkpart p 0 100%
(parted) quit
mkreiserfs /dev/sdb1
...and all seems to work.

Thank you all very much for your hints.

Regards - Ingo.
