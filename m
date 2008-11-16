Return-Path: <linux-kernel-owner+w=401wt.eu-S1752619AbYKPLLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbYKPLLT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 06:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751777AbYKPLLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 06:11:07 -0500
Received: from mail.gmx.net ([213.165.64.20]:51726 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751722AbYKPLLG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 06:11:06 -0500
X-Authenticated: #34473864
X-Provags-ID: V01U2FsdGVkX18nliQ73WYnvo4YnFcECFoQppCTcwtycs6BXeswfl
	U5fy/yXDY/zTC8
Message-ID: <491FFFC5.9080006@gmx.de>
Date: Sun, 16 Nov 2008 12:11:01 +0100
From: Philipp Kohlbecher <xt28@gmx.de>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: more general identifier for Phoenix BIOS
References: <491EEDE8.5080508@gmx.de> <491F7D88.7080403@zytor.com> <20081116072300.GB19646@elte.hu>
In-Reply-To: <20081116072300.GB19646@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Phoenix BIOSes variously identify their vendor as "Phoenix Technologies, 
LTD" or "Phoenix Technologies LTD" (without the comma.)

This patch makes the identification string in the bad_bios_dmi_table 
more general (following a suggestion by Ingo Molnar), so that both 
versions are handled.

Again, the patched file compiles cleanly and the patch has been tested 
successfully on my machine.

Signed-off-by: Philipp Kohlbecher <xt28@gmx.de>

---

  arch/x86/kernel/setup.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 0fa6790..9d5674f 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -764,7 +764,7 @@ static struct dmi_system_id __initdata 
bad_bios_dmi_table[] = {
  		.callback = dmi_low_memory_corruption,
  		.ident = "Phoenix BIOS",
  		.matches = {
-			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies, LTD"),
+			DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies"),
  		},
  	},
  #endif

Ingo Molnar wrote:
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
>> Philipp Kohlbecher wrote:
>>> My laptop (a Samsung X20) contains a Phoenix BIOS and would 
>>> benefit from patch 1e22436eba84edfec9c25e5a25d09062c4f91ca9 (x86: 
>>> reserve low 64K on AMI and Phoenix BIOS boxen).
>>>
>>> However, according to /sys/class/dmi/id/bios_vendor, the BIOS 
>>> identifies its vendor as "Phoenix Technologies LTD" (sans the 
>>> comma).
> 
> Note that we should do a simpler patch: just change the string to 
> "Phoenix Technologies" and that will provide a proper match. (DMI 
> matches work on substrings too)
> 

Done. (I wasn't sure whether you were saying that *I* should write this 
simpler patch or that you would. Anyway, here it is.)
