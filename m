Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753321Ab0BCF4G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 00:56:06 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39962 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0BCF4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 00:56:00 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4B690FCD.2040405@jp.fujitsu.com>
Date: Wed, 03 Feb 2010 14:55:25 +0900
From: Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
       Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christoph Hellwig <hch@infradead.org>, Joe Perches <joe@perches.com>,
       Tomohiro Kusumi <kusumi.tomohiro@jp.fujitsu.com>,
       lkml <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com>
Subject: Re: [PATCH 2/2 v2] scsi: add scsi trace core function and put trace
 points
References: <4B665EC9.6000608@jp.fujitsu.com>	<4B666181.7080200@jp.fujitsu.com> <yq1636fqlkv.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1636fqlkv.fsf@sermon.lab.mkp.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Kei" == Kei Tokunaga <tokunaga.keiich@jp.fujitsu.com> writes:
> 
> I'm traveling so I won't have time to look at this closely until next
> week.  However, this caught my eye:
> 
> +static const char *
> +scsi_trace_varlen(struct trace_seq *p, unsigned char *cdb, int len)
> +{
> +	switch (SERVICE_ACTION(cdb)) {
> +	case READ_32:
> +	case WRITE_32:
> +		/* if protection is enabled */
> +		if (((cdb[10] >> 5) & 0x7) == 1)
> +			return scsi_trace_rw32(p, cdb, len);
> +		/* fall through */
> +	default:
> +		return scsi_trace_misc(p, cdb, len);
> +	}
> +}
> 
> It is not a requirement that a 32-byte READ/WRITE request must have
> PROTECT set.  So that if statement is bogus.

Yes.  I agree that the if statement is not necessary here.  I'll
fix it.  Thanks for having your time for the review.

Kei

