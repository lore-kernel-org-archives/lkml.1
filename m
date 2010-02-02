Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0BBXNQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 18:13:16 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:23562 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757106Ab0BBXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 18:13:15 -0500
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Martin Peterson <martin.petersen@oracle.com>,
       Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [PATCH 2/2 v2] scsi: add scsi trace core function and put trace points
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B665EC9.6000608@jp.fujitsu.com>
	<4B666181.7080200@jp.fujitsu.com>
Date: Tue, 02 Feb 2010 18:12:00 -0500
In-Reply-To: <4B666181.7080200@jp.fujitsu.com> (Kei Tokunaga's message of
	"Mon, 01 Feb 2010 14:07:13 +0900")
Message-ID: <yq1636fqlkv.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B68B161.0275:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:

I'm traveling so I won't have time to look at this closely until next
week.  However, this caught my eye:

+static const char *
+scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
+{
+	switch (SERVICE_ACTION(cdb)) {
+	case READ_32:
+	case WRITE_32:
+		/* if protection is enabled */
+		if (((cdb[10] >> 5) & 0x7) == 1)
+			return scsi_trace_rw32(p, cdb, len);
+		/* fall through */
+	default:
+		return scsi_trace_misc(p, cdb, len);
+	}
+}

It is not a requirement that a 32-byte READ/WRITE request must have
PROTECT set.  So that if statement is bogus.

-- 
Martin K. Petersen	Oracle Linux Engineering
