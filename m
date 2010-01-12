Return-Path: <linux-kernel-owner+w=401wt.eu-S1753578Ab0ALTKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab0ALTKV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 14:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751445Ab0ALTKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 14:10:20 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:58601 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0ALTKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 14:10:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=YWSwmEjAvASesuCGhJrDNo7kRR0J5oGmjal3d+elr0JFuCUkNE6uoOdoVMCZQu11Xz
         UtfDyWsJBMGq9tnAPai/jbOmtUW+cvoTxYZY1lL4tgnMFl4T+dOEQ2u5hwxjI17+ZGNE
         h7oaQv0V8UUUYeOd5ct3jn80bTrWEmiT5lKIY=
MIME-Version: 1.0
In-Reply-To: <1263246829.2859.537.camel@sbs-t61.sc.intel.com>
References: <20100109101038.GA17555@in.ibm.com>
	 <86802c441001091313y1f64f011t616f08cd282a7123@mail.gmail.com>
	 <20100110023015.GA2253@in.ibm.com>
	 <86802c441001092235j79092e6fse18b61e3d7b0ac6@mail.gmail.com>
	 <20100110102638.GA7838@elte.hu>
	 <86802c441001111343p2afaafb7o702884e632260bf7@mail.gmail.com>
	 <1263246829.2859.537.camel@sbs-t61.sc.intel.com>
Date: Tue, 12 Jan 2010 11:10:19 -0800
X-Google-Sender-Auth: 9670e8bd49b573d7
Message-ID: <86802c441001121110u2f3dcfbpafb0d9c4bb6a4e4d@mail.gmail.com>
Subject: Re: [PATCH] Make Intel 8-way Xeons boot again
From: Yinghai Lu <yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

if the system can not use logical flat.

should have some bit set in FADT...

static int physflat_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
{
#ifdef CONFIG_ACPI
        /*
         * Quirk: some x86_64 machines can only use physical APIC mode
         * regardless of how many processors are present (x86_64 ES7000
         * is an example).
         */
        if (acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID &&
                (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL)) {
                printk(KERN_DEBUG "system APIC only can use physical flat");
                return 1;
        }
#endif

        return 0;
}
