Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbZELPyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbZELPyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 11:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752614AbZELPyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 11:54:00 -0400
Received: from gw-ca.panasas.com ([209.116.51.66]:19325 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753368AbZELPx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 11:53:58 -0400
Message-ID: <4A099B8A.1020401@panasas.com>
Date: Tue, 12 May 2009 18:53:46 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090315 Remi/3.0-0.b2.fc10.remi Thunderbird/3.0b2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org> <4A0946D6.4010405@panasas.com> <4A094A11.2030300@kernel.org> <4A09589A.5030800@panasas.com> <4A0993BA.7090505@kernel.org>
In-Reply-To: <4A0993BA.7090505@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2009 15:53:57.0863 (UTC) FILETIME=[DC314770:01C9D319]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2009 06:20 PM, Tejun Heo wrote:
> Boaz Harrosh wrote:
> 
>> The solution to this, I think, is that the bouncing layer should
>> receive a residual count, and not bounce anything beyond what's
>> transferred. (On reads, writes does nothing), and zero-out the
>> rest. This of course means that all block drivers make sure residual
>> is properly set, the way it should as explained in this
>> thread. (SCSI does the right thing where it can, for example see
>> scsi_execute())
> 
> Umm... shouldn't the request just be successfully finished with
> positive residue count and with sense data if necessary?  Block layer
> request failure means, and has always meant, complete failure.
> 

I see, however if so then bouncing must take into consideration the residual
count in the successful case, so not to copy garbage bytes. And drivers audited
to make sure residual is set accordingly.

I wish we would set resid_len to data_len at begining and let drivers
reset that on success properly, like SCSI does. I'll look at it farther
when I have a bit of time.

Finally I see a distinct separate usage for the request->error member?

> Thanks.
> 

Thanks
Boaz
