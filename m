Return-Path: <linux-kernel-owner+w=401wt.eu-S1755676AbYHMLvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676AbYHMLvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 07:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbYHMLvP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 07:51:15 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:4775 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYHMLvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 07:51:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:sender;
        b=bzx5rTd45WYHl8TIbdXiGsTYyUT74w6oABxVd7C5Yw69HbqEhQ4vtuoctG2afLEtel
         EDyRbwaqZ9UXypQJqcMKk9j23nl9It9EPFRUEjZ1sAX9b54si5RxpnCBTHEAbznI8gXu
         fclaSjIb/SWtbDYE/dr8Rd+FDICgKD63OHt5A=
Message-ID: <48A2CAAA.7010405@tuffmail.co.uk>
Date: Wed, 13 Aug 2008 12:51:06 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, hmh@hmh.eng.br,
       Maximilian Engelhardt <maxi@daemonizer.de>, stable@kernel.org
Subject: Re: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
References: <487D23C3.5070301@student.cs.york.ac.uk>	<487F58B6.5040309@suse.de>	<487F6D2E.2040501@tuffmail.co.uk>	<487F772C.1070806@suse.de>	<487F9592.1060003@tuffmail.co.uk>	<487F9677.4060001@suse.de>	<20080812162854.d6907c95.akpm@linux-foundation.org>	<48A2B596.3050401@tuffmail.co.uk> <20080813034628.0ef51866.akpm@linux-foundation.org>
In-Reply-To: <20080813034628.0ef51866.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------000405000306070004020803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000405000306070004020803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[Dupe apology: CC'd to stable@kernel.org, with the right address this time]

Andrew Morton wrote:
> On Wed, 13 Aug 2008 11:21:10 +0100 Alan Jenkins <alan-jenkins@tuffmail.co.uk> wrote:
>
>   
>> Andrew Morton wrote:
>>     
>>> Did this get fixed yet?
>>>
>>> I have an patch in -mm which I just restored (I had to tempdrop it
>>> because the acpi tree was busted for some time).  But it seems to be
>>> old.
>>>
>>> http://bugzilla.kernel.org/show_bug.cgi?id=10919 is marked "resolved"
>>> but the reporter (Maximilian) seems to think otherwise.  2.6.26.x is,
>>> afaik, still unfixed, as is 2.6.27-rc.
>>>   
>>>       
>> That's correct.  I think this specific patch should go in 2.6.27 and
>> 2.6.26-stable.  No objections have been raised so far.
>>
>> I still need this patch to make my brightness and volume control keys
>> usable in 2.6.27-rc3.  (They auto-repeat fast enough to trigger the
>> bug).  This is true even after applying the latest patches from bug
>> 10919 (#25 + #27).
>>
>>     
>
> Confusing.  Please send the patch which you think we should apply.
>
>   
>> I think the 10919 fix makes it harder to reproduce, but it definitely
>> still happens.  I guess this is because the polling-driven EC
>> transactions add 1ms delays between each byte.  The slower timings leave
>> a window where the buggy behaviour of my EC can make a difference.  (It
>> has been seen to clear the "pending event" bit after a single event is
>> read, despite having more events pending).
>>
>> There are more serious consequences of this bug.  After a while it can
>> confuse the EC enough to cause lockups or reboots during boot, or after
>> pressing a single hotkey.  This bad state is preserved over reboots,
>> even into known good kernels.  Fortunately the badness clears when power
>> is removed for a long enough period.  For a while I was worried that
>> something had physically burnt out.
>>     
>
> Oh gad.  And there's no workaround?
>
Sorry, that was confusing.

The patch in currently in -mm _is_ the workaround for this damage.  It
was not initially obvious just how important it was :-).  I've
re-attached it as requested.

10919, "laggy hotkeys" is just what it says; ACPI EC events are slower
because of polling.  It appears to be a more cosmetic issue which is
orthogonal to the _dropping_ of events.

Thanks
Alan


--------------000405000306070004020803
Content-Type: message/rfc822;
 name="Attached Message"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="Attached Message"

Return-Path: <alan.christopher.jenkins@googlemail.com>
Received: from ?10.222.147.177? ( [86.53.68.233])
        by mx.google.com with ESMTPS id q9sm4420015gve.5.2008.07.15.15.24.46
        (version=SSLv3 cipher=RC4-MD5);
        Tue, 15 Jul 2008 15:24:47 -0700 (PDT)
Message-ID: <487D23C3.5070301@student.cs.york.ac.uk>
Date: Tue, 15 Jul 2008 23:25:07 +0100
From: Alan Jenkins <aj504@student.cs.york.ac.uk>
Reply-To: alan-jenkins@tuffmail.co.uk
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: astarikovskiy@suse.de
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] acpi: Avoid dropping rapid hotkey events (or other GPEs)
 on Asus EeePC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: Alan Jenkins <alan.christopher.jenkins@googlemail.com>

It looks like this EC clears the SMI_EVT bit after every query, even if there
are more events pending.  The workaround is to repeatedly query the EC until
it reports that no events remain.

This fixes a regression in 2.6.26 (from 2.6.25.3).  Initially reported as
"Asus Eee PC hotkeys stop working if pressed quickly" in bugzilla
<http://bugzilla.kernel.org/show_bug.cgi?id=11089>.

The regression was caused by a recently added check for interrupt storms.
The Eee PC triggers this check and switches to polling.  When multiple events
arrive between polling intervals, only one is fetched from the EC.  This causes
erroneous behaviour; ultimately events stop being delivered altogether when the
EC buffer overflows.

Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

---
diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index 5622aee..2b4c5a2 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -459,14 +459,10 @@ void acpi_ec_remove_query_handler(struct acpi_ec *ec, u8 query_bit)
 
 EXPORT_SYMBOL_GPL(acpi_ec_remove_query_handler);
 
-static void acpi_ec_gpe_query(void *ec_cxt)
+static void acpi_ec_gpe_run_handler(struct acpi_ec *ec, u8 value)
 {
-	struct acpi_ec *ec = ec_cxt;
-	u8 value = 0;
 	struct acpi_ec_query_handler *handler, copy;
 
-	if (!ec || acpi_ec_query(ec, &value))
-		return;
 	mutex_lock(&ec->lock);
 	list_for_each_entry(handler, &ec->list, node) {
 		if (value == handler->query_bit) {
@@ -484,6 +480,18 @@ static void acpi_ec_gpe_query(void *ec_cxt)
 	mutex_unlock(&ec->lock);
 }
 
+static void acpi_ec_gpe_query(void *ec_cxt)
+{
+	struct acpi_ec *ec = ec_cxt;
+	u8 value = 0;
+
+	if (!ec)
+		return;
+
+	while (!acpi_ec_query(ec, &value))
+		acpi_ec_gpe_run_handler(ec, value);
+}
+
 static u32 acpi_ec_gpe_handler(void *data)
 {
 	acpi_status status = AE_OK;




--------------000405000306070004020803--
