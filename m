Return-Path: <linux-kernel-owner+w=401wt.eu-S1758369AbYEMHQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369AbYEMHQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753740AbYEMHP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:15:57 -0400
Received: from relay1.sgi.com ([192.48.171.29]:36220 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbYEMHP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:15:56 -0400
Message-ID: <48294022.2070002@sgi.com>
Date: Tue, 13 May 2008 09:15:46 +0200
From: Jes Sorensen <jes@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jeremy Higdon <jeremy@sgi.com>, dgc@sgi.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, jens.axboe@oracle.com, stable@kernel.org
Subject: Re: [PATCH] drivers/scsi/qla1280.c; was Re: Buffered I/O to block
 device very slow and other SCSI issues...
References: <20080319231654.GA103321673@sgi.com>	<20080320010807.GA27620@sgi.com>	<20080320032010.e640c52a.akpm@linux-foundation.org>	<20080512061703.GC41683@sgi.com> <20080512171849.21d3508f.akpm@linux-foundation.org>
In-Reply-To: <20080512171849.21d3508f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
>> --- a/drivers/scsi/qla1280.c	2008-05-03 11:59:44.000000000 -0700
>> +++ b/drivers/scsi/qla1280.c	2008-05-10 21:32:23.451341969 -0700
>> @@ -2007,7 +2007,7 @@ qla1280_set_defaults(struct scsi_qla_hos
>>  		nv->bus[bus].config_2.req_ack_active_negation = 1;
>>  		nv->bus[bus].config_2.data_line_active_negation = 1;
>>  		nv->bus[bus].selection_timeout = 250;
>> -		nv->bus[bus].max_queue_depth = 256;
>> +		nv->bus[bus].max_queue_depth = 32;
>>  
>>  		if (IS_ISP1040(ha)) {
>>  			nv->bus[bus].bus_reset_delay = 3;
>> @@ -2051,7 +2051,7 @@ qla1280_config_target(struct scsi_qla_ho
>>  	status = qla1280_mailbox_command(ha, 0x0f, mb);
>>  
>>  	/* Save Tag queuing enable flag. */
>> -	flag = (BIT_0 << target) & mb[0];
>> +	flag = (BIT_0 << target);
>>  	if (nv->bus[bus].target[target].parameter.tag_queuing)
>>  		ha->bus_settings[bus].qtag_enables |= flag;
> 
> Thanks.  I tagged this for a -stable backport (assuming that is
> appropriate?)
> 

Sounds good, given the nature of this it should go into stable as well
as current.

Acked-by: Jes Sorensen <jes@sgi.com>

Cheers,
Jes

