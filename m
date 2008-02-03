Return-Path: <linux-kernel-owner+w=401wt.eu-S936369AbYBCGVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936369AbYBCGVZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 01:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758178AbYBCGVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 01:21:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49746 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753391AbYBCGVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 01:21:17 -0500
Message-ID: <47A55D2A.2070902@cn.fujitsu.com>
Date: Sun, 03 Feb 2008 14:20:26 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mxser: fix compile warning building without CONFIG_PCI
References: <47A52E20.7000608@cn.fujitsu.com> <47A55C5E.70305@gmail.com>
In-Reply-To: <47A55C5E.70305@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> On 02/03/2008 03:59 AM, Li Zefan wrote:
>> When build without CONFIG_PIC, got the following warnings:
>>
>> drivers/char/mxser.c: In function 'mxser_init':
>> drivers/char/mxser.c:698: warning: unused variable 'devnum'
>> drivers/char/mxser.c:698: warning: unused variable 'busnum'
>> drivers/char/mxser.c:697: warning: unused variable 'index'
>> drivers/char/mxser.c:696: warning: unused variable 'pdev'
>> drivers/char/mxser.c:695: warning: unused variable 'n'
>>
>> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
>> ---
>>  drivers/char/mxser.c |   14 ++++++--------
>>  1 files changed, 6 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
>> index fd0abef..b2cc93d 100644
>> --- a/drivers/char/mxser.c
>> +++ b/drivers/char/mxser.c
>> @@ -692,10 +692,7 @@ static int mxser_get_PCI_conf(int busnum, int
>> devnum, int board_type, struct mxs
>>  
>>  static int mxser_init(void)
>>  {
>> -    int i, m, retval, b, n;
>> -    struct pci_dev *pdev = NULL;
>> -    int index;
>> -    unsigned char busnum, devnum;
>> +    int i, m, retval, b;
>>      struct mxser_hwconf hwconf;
>>  
>>      mxvar_sdriver = alloc_tty_driver(MXSER_PORTS + 1);
>> @@ -834,10 +831,11 @@ static int mxser_init(void)
>>  
>>      /* start finding PCI board here */
>>  #ifdef CONFIG_PCI
>> -    n = ARRAY_SIZE(mxser_pcibrds) - 1;
>> -    index = 0;
>>      b = 0;
>> -    while (b < n) {
>> +    while (b < ARRAY_SIZE(mxser_pcibrds)-1) {
>> +        unsigned char busnum, devnum;
>> +        struct pci_dev *pdev;
>> +
>>          pdev = pci_get_device(mxser_pcibrds[b].vendor,
>>                  mxser_pcibrds[b].device, pdev);
>>          if (pdev == NULL) {
> 
> This version of driver is no longer in -mm.
> 

I didn't know this, so just silently ignore this patch. :)
