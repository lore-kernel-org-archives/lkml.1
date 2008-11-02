Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYKBNVi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYKBNVi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 08:21:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYKBNV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 08:21:29 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57747 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443AbYKBNV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 08:21:28 -0500
Message-ID: <490DA954.2070503@garzik.org>
Date: Sun, 02 Nov 2008 08:21:24 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata fixes
References: <20081031054949.GA10474@havoc.gtf.org> <87f94c370810310620u77f2b31r85b196d7261ef75f@mail.gmail.com>
In-Reply-To: <87f94c370810310620u77f2b31r85b196d7261ef75f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> On Fri, Oct 31, 2008 at 1:49 AM, Jeff Garzik <jeff@garzik.org> wrote:
>> Notes:
>>
>> 1) 1.5TB drive fix from Roland
>>
>> 2) Tejun's sata_via brings a non-working via configuration thanks to a
>>   new facility also being used in recent (ICH9/10) ata_piix.
>>
>>   Change is longer than one might like, but it accurately describes the
>>   hardware now, the previous stuff wasn't working, and the newly added
>>   support code shouldn't touch non-broken VIA controllers.
>>
>>
>>
>> Please pull from 'upstream-linus' branch of
>> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus
>>
>> to receive the following updates:
>>
>>  drivers/ata/ata_piix.c    |    1 -
>>  drivers/ata/libata-core.c |   11 +++-
>>  drivers/ata/sata_via.c    |  155 +++++++++++++++++++++++++++++++++++++++++----
>>  include/linux/libata.h    |    1 +
>>  4 files changed, 152 insertions(+), 16 deletions(-)
>>
>> Jens Axboe (1):
>>      libata: add whitelist for devices with known good pata-sata bridges
>>
>> Randy Dunlap (1):
>>      ATA: remove excess kernel-doc notation
>>
>> Roland Dreier (1):
>>      libata: Avoid overflow in ata_tf_to_lba48() when tf->hba_lbal > 127
>>
>> Tejun Heo (1):
>>      sata_via: fix support for 5287
> <snip>
> 
>> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
>> index 2ff633c..82af701 100644
>> --- a/drivers/ata/libata-core.c
>> +++ b/drivers/ata/libata-core.c
>> @@ -1268,7 +1268,7 @@ u64 ata_tf_to_lba48(const struct ata_taskfile *tf)
>>
>>        sectors |= ((u64)(tf->hob_lbah & 0xff)) << 40;
>>        sectors |= ((u64)(tf->hob_lbam & 0xff)) << 32;
>> -       sectors |= (tf->hob_lbal & 0xff) << 24;
>> +       sectors |= ((u64)(tf->hob_lbal & 0xff)) << 24;
>>        sectors |= (tf->lbah & 0xff) << 16;
>>        sectors |= (tf->lbam & 0xff) << 8;
>>        sectors |= (tf->lbal & 0xff);
> <snip>
> 
> That looks really serious.
> 
> What happens with all previous / stable kernels when connecting up a
> 1.5TB drive and the user tries to use the last portion of the drive?

tf-to-lba48 is a far less common operation, generally used for error 
reporting (and in Host-Protected Area code as well, it appears).

	Jeff




