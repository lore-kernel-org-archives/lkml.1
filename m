Return-Path: <linux-kernel-owner+w=401wt.eu-S1762390AbXKOO7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762390AbXKOO7J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 09:59:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758207AbXKOO65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 09:58:57 -0500
Received: from neopsis.com ([213.239.204.14]:44795 "EHLO
	matterhorn.dbservice.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758121AbXKOO64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 09:58:56 -0500
Message-ID: <473C5EA3.7020101@dbservice.com>
Date: Thu, 15 Nov 2007 15:58:43 +0100
From: Tomas Carnecky <tom@dbservice.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070802)
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: statically allocated input_dev
References: <20071115094309.innulage80owccko@www.neopsis.com>	 <d120d5000711150556r18842b09o2ed5ef3db7abd3d9@mail.gmail.com>	 <473C5595.3010403@dbservice.com> <d120d5000711150630n538a78e3sd3676a19eb051327@mail.gmail.com>
In-Reply-To: <d120d5000711150630n538a78e3sd3676a19eb051327@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Neopsis-MailScanner-Information: Neopsis MailScanner using ClamAV and Spaassassin
X-Neopsis-MailScanner: Found to be clean
X-Neopsis-MailScanner-SpamCheck: not spam, SpamAssassin (score=-2.281,
	required 5, autolearn=spam, AWL 0.22, BAYES_00 -2.60,
	RDNS_DYNAMIC 0.10)
X-MailScanner-From: tom@dbservice.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

CC: lkml, because that's a question anyone familiar with the driver
subsystem can answer.

Dmitry Torokhov wrote:
> On Nov 15, 2007 9:20 AM, Tomas Carnecky <tom@dbservice.com> wrote:
>> Dmitry Torokhov wrote:
>>> No, sorry. Current object lifetime rules require input devices (as
>>> well as platform devices) to be dynamically allocated.
>>>
>> Interesting, especially the 'platform device' bit, because, from
>> ./drivers/block/floppy.c:
>>
>>    floppy_device[drive].name = floppy_device_name;
>>    floppy_device[drive].id = drive;
>>    floppy_device[drive].dev.release = floppy_device_release;
>>
>>    err = platform_device_register(&floppy_device[drive]);
>>
>> where 'floppy_device' is a static array defined as follows:
>>
>>    static struct platform_device floppy_device[N_DRIVE];
>>
>> So is that code incorrect?
>>
> 
> I would not look at floopy code when searching for examples ;)
> 

Statically allocating platform devices works, I can register those just
fine and I don't see any oops when loading/removing the module. Even
though there are no signs of breakage, should I change my code anyway?

I'm trying to keep the code as simple as possible. The platform device,
platform driver and the input device will live only as long as the
module is loaded. There is nothing else that would rely or depend on my
driver. Any advices you can give? Or is there nothing that I could use
to keep the code simple?

tom
