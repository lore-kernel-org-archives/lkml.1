Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106Ab0ATH7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106Ab0ATH7p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752508Ab0ATH7n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:59:43 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:63118 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab0ATH7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:59:42 -0500
To: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] scsi: add scsi trace core function and put trace points
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B56A621.2070301@jp.fujitsu.com>
Date: Wed, 20 Jan 2010 02:58:34 -0500
In-Reply-To: <4B56A621.2070301@jp.fujitsu.com> (Kei Tokunaga's message of
	"Wed, 20 Jan 2010 15:43:45 +0900")
Message-ID: <yq1ockpky1h.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B56B7CE.0157:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:

+	TP_printk("host_no=%u channel=%u id=%u lun=%u cmnd=(%s %s raw=%s) "
                              ^^^^^^^^^^

I'm not sure anybody cares about channels in this millennium so that may
be a waste of space.


+scsi_trace_rw10(struct trace_seq *p, unsigned char *cdb, int len)
+scsi_trace_rw12(struct trace_seq *p, unsigned char *cdb, int len)
+scsi_trace_rw16(struct trace_seq *p, unsigned char *cdb, int len)
+scsi_trace_rw32(struct trace_seq *p, unsigned char *cdb, int len)

Would be handy to get FUA and {RD,WR}PROTECT decoded in these commands.
And prot_op would be nice too.

Other decode-worthy commands might be WRITE SAME(16) and UNMAP.


+scsi_trace_parse_cdb(struct trace_seq *p, unsigned char *cdb, int len)
+{
        [...]
+	case READ_32:
+	case WRITE_32:
+		return scsi_trace_rw32(p, cdb, len);

This won't work.  READ/WRITE(32) are variable length commands.  They
share the same operation code and are distinguished by the service
action field.  Several of the most recent additions to the SCSI
protocols are implemented like this.

Other commands requiring two-level parsing are READ CAPACITY(16) and GET
LBA STATUS.

-- 
Martin K. Petersen	Oracle Linux Engineering
