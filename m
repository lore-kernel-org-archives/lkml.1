Return-Path: <linux-kernel-owner+w=401wt.eu-S1763596AbYD3SZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763596AbYD3SZF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758200AbYD3SYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:24:54 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:24500 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbYD3SYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:24:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=CBMhG+Ijm1iotPYn3pCp7C9Z8I+LUIXzM55EwxoYGESMxdPQJ5HKwTpfoWMWCbVifrLmekqGT3bFphNw87e2ltdzOhQr8tz6zi6IdcTrJbwIxU5u0kX5+sVcquJ1J/vnmAFVDT8p5cQUlNXBvRgvlAx+cRUBdAmxBYT4mqrBHTo=
Message-ID: <4818B963.7000108@googlemail.com>
Date: Wed, 30 Apr 2008 20:24:35 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, wim@iguana.be
Subject: Re: [PATCH] iTCO_wdt: ICH9DO support
References: <4818875E.7020703@googlemail.com> <20080430111508.2dc5b26c.akpm@linux-foundation.org>
In-Reply-To: <20080430111508.2dc5b26c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 30 Apr 2008 16:51:10 +0200
> Gabriel C <nix.or.die@googlemail.com> wrote:
> 
>> -#define DRV_VERSION     "1.02"
>> -#define DRV_RELDATE     "26-Jul-2007"
>> +#define DRV_VERSION     "1.03"
>> +#define DRV_RELDATE     "30-Apr-2008"
> 
> lol.  git-watchdog changes these to
> 
> #define DRV_VERSION     "1.10"
> #define DRV_RELDATE     "17-Aug-2007"
> 
> Version numbers and dates like this really are pretty pointless.  If you
> get a report against "v1.10", it just is not useful information.  You still
> need to ask "what kernel version" to be able to reliably locate the source
> for the reporter's driver.
> 
> 
> But it's a great way to generate .rej files.

Really sorry Andrew here the patch without the changes to the driver version.


--

This patch adds the Intel ICH9DO controller ID's for 
the iTCO_wdt kernel driver.


Tested on an P5E-VM DO ASUS motherboard.

Signed-off-by: Gabriel Craciunescu <nix.or.die@googlemail.com>

---

 drivers/watchdog/iTCO_wdt.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/watchdog/iTCO_wdt.c b/drivers/watchdog/iTCO_wdt.c
index a0e6809..7d3203a 100644
--- a/drivers/watchdog/iTCO_wdt.c
+++ b/drivers/watchdog/iTCO_wdt.c
@@ -44,6 +44,7 @@
  *	82801IB  (ICH9)      : document number 316972-001, 316973-001,
  *	82801IR  (ICH9R)     : document number 316972-001, 316973-001,
  *	82801IH  (ICH9DH)    : document number 316972-001, 316973-001,
+ *	82801IO  (ICH9DO)    : document number 316972-001, 316973-006,
  *	6300ESB  (6300ESB)   : document number 300641-003, 300884-010,
  *	631xESB  (631xESB)   : document number 313082-001, 313075-005,
  *	632xESB  (632xESB)   : document number 313082-001, 313075-005
@@ -104,6 +105,7 @@ enum iTCO_chipsets {
 	TCO_ICH9,	/* ICH9 */
 	TCO_ICH9R,	/* ICH9R */
 	TCO_ICH9DH,	/* ICH9DH */
+	TCO_ICH9DO,     /* ICH9DO */
 	TCO_631XESB,	/* 631xESB/632xESB */
 };
 
@@ -136,6 +138,7 @@ static struct {
 	{"ICH9", 2},
 	{"ICH9R", 2},
 	{"ICH9DH", 2},
+	{"ICH9DO", 2},
 	{"631xESB/632xESB", 2},
 	{NULL,0}
 };
@@ -181,6 +184,7 @@ static struct pci_device_id iTCO_wdt_pci_tbl[] = {
 	{ ITCO_PCI_DEVICE(0x2918,				TCO_ICH9   )},
 	{ ITCO_PCI_DEVICE(0x2916,				TCO_ICH9R  )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_2,		TCO_ICH9DH )},
+	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ICH9_4,           TCO_ICH9DO )},
 	{ ITCO_PCI_DEVICE(PCI_DEVICE_ID_INTEL_ESB2_0,		TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2671,				TCO_631XESB)},
 	{ ITCO_PCI_DEVICE(0x2672,				TCO_631XESB)},
