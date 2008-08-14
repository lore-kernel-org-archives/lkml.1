Return-Path: <linux-kernel-owner+w=401wt.eu-S1759623AbYHNODU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759623AbYHNODU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:03:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbYHNODG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:03:06 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55274 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757AbYHNODD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:03:03 -0400
Message-ID: <48A4397C.8070602@redhat.com>
Date: Thu, 14 Aug 2008 15:56:12 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Dominik Brodowski <linux@dominikbrodowski.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@suse.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       ACPI mailing list <linux-acpi@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Thomas Renninger <trenn@suse.de>, stable@kernel.org
Subject: Re: 2.6.27-rc1: critical thermal shutdown on thinkpad x60 (bisected)
References: <20080806090246.GA1572@elf.ucw.cz> <48A1779B.5020303@redhat.com> <20080812115530.GB8806@elf.ucw.cz> <200808121634.34634.rjw@sisk.pl> <48A1A4F6.9080706@redhat.com> <48A1B0CB.9050908@redhat.com> <20080812183004.GA24211@isilmar.linta.de> <20080812185941.GE1366@one.firstfloor.org>
In-Reply-To: <20080812185941.GE1366@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(adding cc: stable, the bug is also in 2.6.26.2)

Andi Kleen wrote:

> On Tue, Aug 12, 2008 at 08:30:04PM +0200, Dominik Brodowski wrote:
>   
>> Hi,
>>
>> On Tue, Aug 12, 2008 at 05:48:27PM +0200, Milan Broz wrote:
>>     
>>> -static unsigned int ignore_ppc = -1;
>>> +static int ignore_ppc = -1;
>>>  module_param(ignore_ppc, uint, 0644);
>>>       
>> 			    ^^^^
>> follow-up change?
>>     
yep, thanks.
I am running my x60s with this patch now:

--

Fix signed parameter in ACPI frequency notifier.

  static unsigned int ignore_ppc = -1;
...
       if (event == CPUFREQ_START && ignore_ppc <= 0) {
               ignore_ppc = 0;
...

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/acpi/processor_perflib.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.26.y/drivers/acpi/processor_perflib.c
===================================================================
--- linux-2.6.26.y.orig/drivers/acpi/processor_perflib.c	2008-08-12 17:20:07.000000000 +0200
+++ linux-2.6.26.y/drivers/acpi/processor_perflib.c	2008-08-13 09:32:38.000000000 +0200
@@ -70,8 +70,8 @@ static DEFINE_MUTEX(performance_mutex);
  *  0 -> cpufreq low level drivers initialized -> consider _PPC values
  *  1 -> ignore _PPC totally -> forced by user through boot param
  */
-static unsigned int ignore_ppc = -1;
-module_param(ignore_ppc, uint, 0644);
+static int ignore_ppc = -1;
+module_param(ignore_ppc, int, 0644);
 MODULE_PARM_DESC(ignore_ppc, "If the frequency of your machine gets wrongly" \
 		 "limited by BIOS, this should help");
 



