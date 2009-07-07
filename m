Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbZGGPTV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbZGGPTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:19:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753713AbZGGPTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:19:12 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:35504 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbZGGPTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:19:11 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19027.26456.343392.704453@stoffel.org>
Date: Tue, 7 Jul 2009 11:18:48 -0400
From: "John Stoffel" <john@stoffel.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: John Stoffel <john@stoffel.org>, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH] Make SCSI SG v4 driver enabled by default now since udev
 depends on it.
In-Reply-To: <4A53644E.2090205@panasas.com>
References: <1246978255-19407-1-git-send-email-john@stoffel.org>
	<4A53644E.2090205@panasas.com>
X-Mailer: VM 8.0.9 under Emacs 22.3.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Boaz" == Boaz Harrosh <bharrosh@panasas.com> writes:

Boaz> On 07/07/2009 05:50 PM, John Stoffel wrote:
>> Signed-off-by: John Stoffel <john@stoffel.org>
>> ---
>> block/Kconfig |    6 +++---
>> 1 files changed, 3 insertions(+), 3 deletions(-)
>> 
>> diff --git a/block/Kconfig b/block/Kconfig
>> index e7d1278..22bf6eb 100644
>> --- a/block/Kconfig
>> +++ b/block/Kconfig
>> @@ -46,8 +46,8 @@ config LBD
>> 
>> config BLK_DEV_BSG
>> bool "Block layer SG support v4 (EXPERIMENTAL)"

Boaz> Please also remove the (EXPERIMENTAL) from the prompt as well

Duh... sorry for this oversight.  I'll respin the patch ASAP.

>> -	depends on EXPERIMENTAL
>> -	---help---
>> +	default y
>> +	help
>> Saying Y here will enable generic SG (SCSI generic) v4 support
>> for any block device.
>> 
>> @@ -57,7 +57,7 @@ config BLK_DEV_BSG
>> protocols (e.g. Task Management Functions and SMP in Serial
>> Attached SCSI).
>> 
>> -	  If unsure, say N.
>> +	  If unsure, say Y.
>> 
>> config BLK_DEV_INTEGRITY
>> bool "Block layer data integrity support"

Boaz> Thanks I needed that too.

Boaz> BTW distro(s) have been shipping with it on for ages

I ran into this since I was trying to get Udev to properly find and
name my tape drives, and it wasn't until I finally figured out that
BSG wasn't enabled on any of my systems that I got around to getting
it working properly.

I've also put in a patch to the UDEV people to mention that this
should be turned on to make Udev work properly.

John
