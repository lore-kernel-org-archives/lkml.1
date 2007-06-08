Return-Path: <linux-kernel-owner+w=401wt.eu-S1031231AbXFHSNQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031231AbXFHSNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 14:13:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969663AbXFHSM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 14:12:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54091 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763961AbXFHSM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 14:12:56 -0400
Date: Fri, 8 Jun 2007 11:12:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Luming Yu" <luming.yu@gmail.com>
Cc: "Andy Whitcroft" <apw@shadowen.org>, linux-kernel@vger.kernel.org,
       "Len Brown" <len.brown@intel.com>, "Yu, Luming" <luming.yu@intel.com>,
       "Alexey Starikovskiy" <alexey.y.starikovskiy@intel.com>,
       linux-acpi@vger.kernel.org
Subject: Re: 2.6.22-rc4-mm1 -- x86_64 ACPI panic
Message-Id: <20070608111215.5c492330.akpm@linux-foundation.org>
In-Reply-To: <3877989d0706080215x22f35292g8cb999f8720cd87c@mail.gmail.com>
References: <20070606020737.4663d686.akpm@linux-foundation.org>
	<4666BDF1.6080801@shadowen.org>
	<20070606105223.c8dece17.akpm@linux-foundation.org>
	<3877989d0706080215x22f35292g8cb999f8720cd87c@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 17:15:45 +0800
"Luming Yu" <luming.yu@gmail.com> wrote:

> The only problem known as to the acpi throttling changes in the mm tree
> is a typo ,and the patch to fix it is available here.  Please test and
> get results back to me. BTW,the log shows that the acpi-cpufreq.ko has
> problem. Would please also try not to load acpi-cpufreq.
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0706.0/2509.html

Sigh.  Is this some sort of contest to see how many things we can
do wrong in a single patch?

- Include a changelog

- Include Signed-off-by:

- Don't use attachments

- If you _must_ use attachments, use text/plain, not application/octet-stream

- Format code to remain within 80 columns.

- Don't do "if(".  Do "if ("

Oh well.  Good to hear that the oops got fixed, thanks.


From: "Luming Yu" <luming.yu@gmail.com>

Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/processor_throttling.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff -puN drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show drivers/acpi/processor_throttling.c
--- a/drivers/acpi/processor_throttling.c~acpi-fix-oops-in-acpi_processor_throttling_seq_show
+++ a/drivers/acpi/processor_throttling.c
@@ -656,18 +656,20 @@ static int acpi_processor_throttling_seq
 		   pr->throttling.state_count - 1);
 
 	seq_puts(seq, "states:\n");
-	if (acpi_processor_get_throttling == acpi_processor_get_throttling_fadt)
+	if (pr->throttling.acpi_processor_get_throttling ==
+			acpi_processor_get_throttling_fadt) {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (pr->throttling.states[i].performance ? pr->
 				    throttling.states[i].performance / 10 : 0));
-	else
+	} else {
 		for (i = 0; i < pr->throttling.state_count; i++)
 			seq_printf(seq, "   %cT%d:                  %02d%%\n",
 				   (i == pr->throttling.state ? '*' : ' '), i,
 				   (int)pr->throttling.states_tss[i].
 				   freqpercentage);
+	}
 
       end:
 	return 0;
_

