Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbXKMQAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbXKMQAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbXKMQAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:00:31 -0500
Received: from zcars04f.nortel.com ([47.129.242.57]:37415 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbXKMQAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:00:30 -0500
Message-ID: <4739CA10.6080601@nortel.com>
Date: Tue, 13 Nov 2007 10:00:16 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: questions on details of sg_ioctl
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Nov 2007 16:00:20.0067 (UTC) FILETIME=[4A757B30:01C8260E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Suppose I send down an SG_IO command on a generic scsi device node.  As 
far as I can tell, the code path looks like this in 2.6.14:

sg_ioctl
	sg_new_write
		scsi_execute_async (sets up sg_cmd_done as callback)
			scsi_do_req
				scsi_insert_special_req
					blk_insert_request

and like this in 2.6.23:
sg_ioctl
	sg_new_write
		scsi_execute_async (sets up sg_cmd_done as callback)
			blk_execute_rq_nowait


At this point, is that request queued along with all the other commands, 
or is it injected immediately to the device?  If it is queued up along 
with all the other commands, shouldn't the return path feed into the 
queue length calculations if we get BUSY/TASK_SET_FULL?

Also, for the purposes of the device returning TASK_SET_FULL vs BUSY, 
does each userspace process count as a SCSI initiator port, or are they 
all sort of grouped together?  (The reason I ask is that we're getting 
TASK_SET_FULL errors but according to SAM-3 that should only happen if 
we already have at least one outstanding request.)

Thanks,

Chris
