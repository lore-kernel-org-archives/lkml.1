Return-Path: <linux-kernel-owner+w=401wt.eu-S1756949AbYBRRO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756949AbYBRRO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYBRROT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 12:14:19 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:33906 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYBRROS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 12:14:18 -0500
Date: Mon, 18 Feb 2008 09:13:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>,
       mike.miller@hp.com
Subject: Re: 2.6.25-rc2-mm1 (cciss build error)
Message-Id: <20080218091357.eb119a08.randy.dunlap@oracle.com>
In-Reply-To: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/

cciss driver has a bad macro definition:

#else /* no CONFIG_CISS_SCSI_TAPE */

/* If no tape support, then these become defined out of existence */

#define cciss_scsi_setup(cntl_num)
#define cciss_unregister_scsi(ctlr)
#define cciss_register_scsi(ctlr)
#define cciss_seq_tape_report(struct seq_file *seq, int ctlr)

#endif /* CONFIG_CISS_SCSI_TAPE */

which causes this error:

In file included from /local/linsrc/linux-2.6.25-rc2-mm1/drivers/block/cciss.c:231:
/local/linsrc/linux-2.6.25-rc2-mm1/drivers/block/cciss_scsi.c:1498:38: error: macro parameters must be comma-separated
make[3]: *** [drivers/block/cciss.o] Error 1

---
~Randy
