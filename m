Return-Path: <linux-kernel-owner+w=401wt.eu-S1759329AbYJINFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759329AbYJINFn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 09:05:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757440AbYJINFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 09:05:35 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45743 "EHLO UNKNOWN"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753479AbYJINFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 09:05:34 -0400
Date: Thu, 9 Oct 2008 15:05:18 +0200
From: Pavel Machek <pavel@suse.cz>
To: "Cihula, Joseph" <joseph.cihula@intel.com>
Cc: linux-kernel@vger.kernel.org, "Wang, Shane" <shane.wang@intel.com>,
       "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 3/3] TXT: Intel(R) TXT and tboot kernel support
Message-ID: <20081009130518.GE1623@ucw.cz>
References: <D936D925018D154694D8A362EEB0892005AC105F@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D936D925018D154694D8A362EEB0892005AC10E3@orsmsx416.amr.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> (large) Patch inline below (and still attached for those who prefer it).
> 
> Linux kernel changes to support tboot and Intel TXT.

Please pick a better acronym. TXT is already taken.

> +struct tboot_acpi_sleep_info {
> +	u16 pm1a_cnt;
> +	u16 pm1b_cnt;
> +	u16 pm1a_evt;
> +	u16 pm1b_evt;
> +	u16 pm1a_cnt_val;
> +	u16 pm1b_cnt_val;
> +}  __attribute__ ((__packed__));
> +
> +struct tboot_shared {
> +	/* version 0x01+ fields: */
> +	struct tboot_uuid uuid; /* TBOOT_SHARED_UUID */
> +	u32  version;      	/* Version number: 2 is current */
> +	u32  log_addr;     	/* physical addr of tb_log_t log */
> +	u32  shutdown_entry32;	/* entry point for tboot shutdown from
> 32b */
> +	u32  shutdown_entry64;	/* entry point for tboot shutdown from
> 64b */

should these be function pointers?

> +	u32  shutdown_type;	/* type of shutdown (TB_SHUTDOWN_*) */
> +	u32  s3_tb_wakeup_entry;/* entry point for tboot s3 wake up */
> +	u32  s3_k_wakeup_entry;	/* entry point for kernel s3 wake up */
> +	struct tboot_acpi_sleep_info
> +		  acpi_sinfo;	/* where kernel put acpi sleep info in
> Sx */
> +	u8   reserved[52];	/* this pad is for compat with old field
> */
> +	/* version 0x02+ fields: */
> +	u32  tboot_base;	/* starting addr for tboot */
> +	u32  tboot_size;	/* size of tboot */
> +} __attribute__ ((__packed__));
> +
> +/* {663C8DFF-E8B3-4b82-AABF-19EA4D057A08} */
> +#define TBOOT_SHARED_UUID     \
> +		((struct tboot_uuid){ 0x663c8dff, 0xe8b3, 0x4b82,
> 0xaabf,   \
> +				{ 0x19, 0xea, 0x4d, 0x5, 0x7a, 0x8 } })

Can we use normal magic number like rest of kernel does?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
