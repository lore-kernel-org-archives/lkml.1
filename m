Return-Path: <linux-kernel-owner+w=401wt.eu-S1761951AbYGBC4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761951AbYGBC4T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 22:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759173AbYGBC4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 22:56:00 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:42789 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759128AbYGBCz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 22:55:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=MpwzCvJp6lJsytEL7t/Ul7Lz4CDcfT+MjurCZkNMdRiAGgYv6m7zEBNNXfLhy/+UR2
         xkY7Mip7hu+ElK6i4x3783vSgFvQ+6bd3jQigD6vwSSkTEZca9PTXV0S8T9HiqYe12IA
         nSPFzEhgedTwU+k8V4zG598pEFYuPhIJAyEOQ=
Message-ID: <486AEE29.2010506@gmail.com>
Date: Wed, 02 Jul 2008 11:55:37 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Mathieu_B=E9rard?= <Mathieu.Berard@crans.org>,
       linux-ide@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: 2.6.25 to 2.6.26-rc8 regression  (related to ahci and acpi _GTF)
References: <4869FB3C.4060509@crans.org> <200807011614.21491.rjw@sisk.pl>
In-Reply-To: <200807011614.21491.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> [Adding CCs.]
> 
> On Tuesday, 1 of July 2008, Mathieu Bérard wrote:
>> Hi,
>> I have a laptop with an ICH6M SATA Controller and a Hitachi hard drive.
>> While it worked well using the ahci module and Linux 2.6.25, 
>> it get randomly 'stuck' for several seconds to several minutes with 2.6.26-rc8.
>> Successive errors progressively reduce the ATA link speed.
>>
>> Passing the libata.noacpi parameter is an effective workaround.
>>
>> Please note that it's not the first time i have this kind of issue, see:
>> http://marc.info/?l=linux-ide&m=117305595312399&w=2
>> This was found to be a bad interaction between my _GTF taskfile, which enable the
>> "Enable Device-Initiated Interface Power State Transitions" feature, and NCQ.
>> The driver was later NCQ blacklisted to correct the problem.

Can you please post the result of "hdparm -I /dev/sda" and full kernel
boot log?  0xca is not a NCQ command so the it's not related to NCQ at
all.  It seems we'll need to filter out DIPM commands from _GTF.

Thanks.

-- 
tejun
