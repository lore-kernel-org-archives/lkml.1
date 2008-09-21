Return-Path: <linux-kernel-owner+w=401wt.eu-S1753054AbYIUUHi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054AbYIUUHi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 16:07:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbYIUUH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 16:07:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.155]:58373 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751462AbYIUUH2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 16:07:28 -0400
Message-ID: <48D6A9BB.1070705@ru.mvista.com>
Date: Mon, 22 Sep 2008 00:08:27 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Mark de Wever <koraq@xs4all.nl>
Cc: Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
References: <20080921185138.GA16310@localhost> <48D69F5A.9010201@ru.mvista.com>
In-Reply-To: <48D69F5A.9010201@ru.mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, I wrote:

>> After updating my kernel to 2.6.26 the output for the ide-tape drive
>> during booting is garbled eg
>> ide-tape: hdd <-> ht0: Seagate <98>ß8A51|1À<81>Üº<98>ß STT20000A rev 
>> 8A51|1À<81>Üº<98>ß

>> This patch fixes the problem by NULL terminating the strings.

>> Regards,
>> Mark de Wever

>> PS: please CC me since I'm not subscribed.
>> PPS: there are more problems with my tapestreamer in 2.6.26 but I'll
>> post a separate message for that.

>> Signed-off-by: Mark de Wever <koraq@xs4all.nl>

>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index 1bce84b..fd87b43 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -2354,6 +2354,10 @@ static void 
>> idetape_get_inquiry_results(ide_drive_t *drive)
>>      ide_fixstring(product_id, 18, 0);
>>      ide_fixstring(fw_rev, 6, 0);

    Hm, I see that every string variable declared there has 2 extra 
characters, and yet the author have managed to make a mistake... these extra 
chars don't seem needed.

MBR, Sergei
