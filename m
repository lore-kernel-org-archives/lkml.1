Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbXAaM3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbXAaM3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 07:29:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933170AbXAaM3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 07:29:34 -0500
Received: from mga06.intel.com ([134.134.136.21]:8532 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933169AbXAaM3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 07:29:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.13,262,1167638400"; 
   d="scan'208"; a="191082936:sNHT24778656"
Message-ID: <45C08BA6.5000209@linux.intel.com>
Date: Wed, 31 Jan 2007 15:29:26 +0300
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Andrew Morton <akpm@osdl.org>, Maciej Rutecki <maciej.rutecki@gmail.com>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
References: <20070129204528.eb8d695e.akpm@osdl.org>	<45BFC442.5000903@gmail.com>	<45BFEDFB.6000500@imap.cc> <20070130172525.f32fb9ea.akpm@osdl.org> <45C07FBF.3080000@imap.cc>
In-Reply-To: <45C07FBF.3080000@imap.cc>
Content-Type: multipart/mixed;
 boundary="------------030202070304010503020206"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030202070304010503020206
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tilman Schmidt wrote:
> On Tue, 30 Jan 2007 17:25:25 -0800, Andrew Morton wrote:
>   
>> On Wed, 31 Jan 2007 02:16:43 +0100
>> Tilman Schmidt <tilman@imap.cc> wrote:
>>
>>     
>>> Am 30.01.2007 23:18 schrieb Maciej Rutecki:
>>>       
>>>> Second problem, power button doesn't work. When I pressed it, I has this
>>>> error:
>>>>
>>>> ACPI Error (evevent-0305): No installed handler for fixed event
>>>> [00000002] [20070126]
>>>>         
>>> Same here, minus the message. (Or perhaps I just don't know where to look.)
>>> Problem also exists in 2.6.20-rc6-mm2. With 2.6.20-rc6-git1 the power
>>> button of this machine works fine.
>>>       
>> That's significant - in your case at least the 2.6.20-rc6-mm3 ACPI update
>> isn't the cause.
>>     
>
> Is there anything specific I should test, or Big Bisect time?
>
>   
This patch should fix the issue...

Regards,
    Alex.

--------------030202070304010503020206
Content-Type: text/plain;
 name="fix-button_c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fix-button_c.patch"

Correct id for fixed buttons.
ACPI_BUTTON_HID_POWERF was changed, but this change was not propogated to button.c,
thus breaking detection of fixed power and sleep buttons.
From: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>


---

 drivers/acpi/button.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index ac86058..c726612 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -75,7 +75,7 @@ static int acpi_button_state_open_fs(str
 static struct acpi_driver acpi_button_driver = {
 	.name = ACPI_BUTTON_DRIVER_NAME,
 	.class = ACPI_BUTTON_CLASS,
-	.ids = "ACPI_FPB,ACPI_FSB,PNP0C0D,PNP0C0C,PNP0C0E",
+	.ids = "button_power,button_sleep,PNP0C0D,PNP0C0C,PNP0C0E",
 	.ops = {
 		.add = acpi_button_add,
 		.remove = acpi_button_remove,

--------------030202070304010503020206--
