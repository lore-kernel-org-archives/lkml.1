Return-Path: <linux-kernel-owner+w=401wt.eu-S1755616AbYFYRop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616AbYFYRop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:44:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYFYRof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:44:35 -0400
Received: from rn-out-0910.google.com ([64.233.170.184]:27725 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYFYRoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=NFKTr1xk0fX0987uyXeXJEMCJ5ktZNN12+09OWx9ydQfbqu+70vk62mT5kpQnAoyBR
         MbcESIBQim8eZT6d3CL5N683lWayPTUfTzvt1Lo0RJ5/cAdwu8OsJgEcxfNuyZv87R4Q
         mq//uUA3WIQPWCzfOSoK9r5oCRQqZ9GVlGY30=
Message-ID: <b217a64f0806251044v53ea1765qa6a8f31371f42018@mail.gmail.com>
Date: Wed, 25 Jun 2008 13:44:33 -0400
From: "Patrick LeBoutillier" <patrick.leboutillier@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: aic94xx: failing under heavy load
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using the aic94xx driver with a AIC-9410W controller (w/6 Seagate
Cheetah SAS drives) and am getting the following errors under heavy
load:

kernel: aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x10
kernel: sas: command 0xffff81083c893700, task 0xffff81083c4459c0,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff8108381b8580, task 0xffff81083d054200,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083e64c080, task 0xffff81083c42a240,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c4f5e40, task 0xffff810836417540,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff8108381b8bc0, task 0xffff81083d054980,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff8108381b8d00, task 0xffff81083c42a840,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c4f5580, task 0xffff81083d054500,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff8108381b8800, task 0xffff810838808080,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff8108381b8a80, task 0xffff81083d054e00,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c893200, task 0xffff810838808c80,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c4d16c0, task 0xffff81083d054680,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c70d5c0, task 0xffff8108376d3b40,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c4d1580, task 0xffff81083c42a9c0,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083e64c940, task 0xffff8108376d3cc0,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c8830c0, task 0xffff810836424e00,
timed out: EH_NOT_HANDLED
kernel: sas: command 0xffff81083c4d1e40, task 0xffff8108364170c0,
timed out: EH_NOT_HANDLED
kernel: sas: Enter sas_scsi_recover_host
kernel: sas: trying to find task 0xffff81083c4459c0
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c4459c0
kernel: aic94xx: tmf tasklet complete
kernel: aic94xx: tmf resp tasklet
kernel: aic94xx: tmf came back
kernel: aic94xx: task not done, clearing nexus
kernel: aic94xx: asd_clear_nexus_tag: PRE
kernel: aic94xx: asd_clear_nexus_tag: POST
kernel: aic94xx: asd_clear_nexus_tag: clear nexus posted, waiting...
kernel: aic94xx: task 0xffff81083c4459c0 done with opcode 0x23 resp
0x0 stat 0x8d but aborted by upper layer!
kernel: aic94xx: asd_clear_nexus_tasklet_complete: here
kernel: aic94xx: asd_clear_nexus_tasklet_complete: opcode: 0x0
kernel: aic94xx: task 0xffff81083d054200 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083c42a240 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff810836417540 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083d054980 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083c42a840 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083d054500 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff810838808080 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083d054e00 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff810838808c80 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083d054680 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff8108376d3b40 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff81083c42a9c0 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff8108376d3cc0 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff810836424e00 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: task 0xffff8108364170c0 done with opcode 0x0 resp 0x0
stat 0x0 but aborted by upper layer!
kernel: aic94xx: came back from clear nexus
kernel: aic94xx: task 0xffff81083c4459c0 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083c4459c0 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c4459c0 is done
kernel: sas: trying to find task 0xffff81083d054200
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054200
kernel: aic94xx: asd_abort_task: task 0xffff81083d054200 done
kernel: aic94xx: task 0xffff81083d054200 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083d054200 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054200 is done
kernel: sas: trying to find task 0xffff81083c42a240
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a240
kernel: aic94xx: asd_abort_task: task 0xffff81083c42a240 done
kernel: aic94xx: task 0xffff81083c42a240 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083c42a240 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a240 is done
kernel: sas: trying to find task 0xffff810836417540
kernel: sas: sas_scsi_find_task: aborting task 0xffff810836417540
kernel: aic94xx: asd_abort_task: task 0xffff810836417540 done
kernel: aic94xx: task 0xffff810836417540 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff810836417540 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff810836417540 is done
kernel: sas: trying to find task 0xffff81083d054980
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054980
kernel: aic94xx: asd_abort_task: task 0xffff81083d054980 done
kernel: aic94xx: task 0xffff81083d054980 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083d054980 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054980 is done
kernel: sas: trying to find task 0xffff81083c42a840
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a840
kernel: aic94xx: asd_abort_task: task 0xffff81083c42a840 done
kernel: aic94xx: task 0xffff81083c42a840 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083c42a840 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a840 is done
kernel: sas: trying to find task 0xffff81083d054500
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054500
kernel: aic94xx: asd_abort_task: task 0xffff81083d054500 done
kernel: aic94xx: task 0xffff81083d054500 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083d054500 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054500 is done
kernel: sas: trying to find task 0xffff810838808080
kernel: sas: sas_scsi_find_task: aborting task 0xffff810838808080
kernel: aic94xx: asd_abort_task: task 0xffff810838808080 done
kernel: aic94xx: task 0xffff810838808080 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff810838808080 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff810838808080 is done
kernel: sas: trying to find task 0xffff81083d054e00
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054e00
kernel: aic94xx: asd_abort_task: task 0xffff81083d054e00 done
kernel: aic94xx: task 0xffff81083d054e00 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083d054e00 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054e00 is done
kernel: sas: trying to find task 0xffff810838808c80
kernel: sas: sas_scsi_find_task: aborting task 0xffff810838808c80
kernel: aic94xx: asd_abort_task: task 0xffff810838808c80 done
kernel: aic94xx: task 0xffff810838808c80 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff810838808c80 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff810838808c80 is done
kernel: sas: trying to find task 0xffff81083d054680
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083d054680
kernel: aic94xx: asd_abort_task: task 0xffff81083d054680 done
kernel: aic94xx: task 0xffff81083d054680 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083d054680 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083d054680 is done
kernel: sas: trying to find task 0xffff8108376d3b40
kernel: sas: sas_scsi_find_task: aborting task 0xffff8108376d3b40
kernel: aic94xx: asd_abort_task: task 0xffff8108376d3b40 done
kernel: aic94xx: task 0xffff8108376d3b40 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff8108376d3b40 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108376d3b40 is done
kernel: sas: trying to find task 0xffff81083c42a9c0
kernel: sas: sas_scsi_find_task: aborting task 0xffff81083c42a9c0
kernel: aic94xx: asd_abort_task: task 0xffff81083c42a9c0 done
kernel: aic94xx: task 0xffff81083c42a9c0 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff81083c42a9c0 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff81083c42a9c0 is done
kernel: sas: trying to find task 0xffff8108376d3cc0
kernel: sas: sas_scsi_find_task: aborting task 0xffff8108376d3cc0
kernel: aic94xx: asd_abort_task: task 0xffff8108376d3cc0 done
kernel: aic94xx: task 0xffff8108376d3cc0 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff8108376d3cc0 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108376d3cc0 is done
kernel: sas: trying to find task 0xffff810836424e00
kernel: sas: sas_scsi_find_task: aborting task 0xffff810836424e00
kernel: aic94xx: asd_abort_task: task 0xffff810836424e00 done
kernel: aic94xx: task 0xffff810836424e00 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff810836424e00 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff810836424e00 is done
kernel: sas: trying to find task 0xffff8108364170c0
kernel: sas: sas_scsi_find_task: aborting task 0xffff8108364170c0
kernel: aic94xx: asd_abort_task: task 0xffff8108364170c0 done
kernel: aic94xx: task 0xffff8108364170c0 aborted, res: 0x0
kernel: sas: sas_scsi_find_task: task 0xffff8108364170c0 is done
kernel: sas: sas_eh_handle_sas_errors: task 0xffff8108364170c0 is done
kernel: sas: --- Exit sas_scsi_recover_host


I am running kernel 2.6.25.8.
Controller firmware (/lib/firmware/aic94xx-seq.fw) is V30.

I have seen a few threads in the mailing list regarding similar errors
but none seem to lead to any kind of solution.

Does anyone have any leads I can follow? I'll be happy to try out
patches if anybody has anything.


Thanks a lot,

Patrick

-- 
=====================
Patrick LeBoutillier
Laval, Québec, Canada
