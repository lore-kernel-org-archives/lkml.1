Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbYDHUss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbYDHUss (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 16:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYDHUsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 16:48:39 -0400
Received: from web30203.mail.mud.yahoo.com ([209.191.69.50]:41531 "HELO
	web30203.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752972AbYDHUsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 16:48:38 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=t3LsBH3h/zsuvkuGOKFxNY0WUSQ11TBxxaSIdKi0ChQfeGf+Z0d9m30pRPs10Xm+hzaq0fhHjEWHhZ40SF2/KwdyW6wiZU1FXEey9GjeMkH3ph4fy6rOpwgRHf/IctjmEIc6udyYCVei6txB5fmUb35y7AFnipl2QPM/ijdbsmA=;
X-YMail-OSG: 77OtXFEVM1kLG5D_B8L8KgXwSmf8EsCs3lI6.zzbrEMsOo8Vw99Krum849axteOIPQ--
Date: Tue, 8 Apr 2008 13:41:58 -0700 (PDT)
From: Rakesh <raksac@yahoo.com>
Subject: megaraid sas driver
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       megaraidlinux@lsi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <96296.65150.qm@web30203.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am curious to ask, why were these lines omitted from
the megaraid SAS driver with kernel version 2.6.15
onwards.

In my opinion these were blocking physical disks which
were part of a RAID set on the controller from being
visible to OS. Is this correct?

Thanks,
Rakesh

----------------
megaraid_sas.c
                /*
 989                 * Don't export physical disk
devices to mid-layer.
 990                 */
 991                if (!MEGASAS_IS_LOGICAL(cmd->scmd)
&&
 992                    (hdr->cmd_status ==
MFI_STAT_OK) &&
 993                    (cmd->scmd->cmnd[0] ==
INQUIRY)) {
 994
 995                        if (((*(u8 *)
cmd->scmd->request_buffer) & 0x1F) ==
 996                            TYPE_DISK) {
 997                                cmd->scmd->result
= DID_BAD_TARGET << 16;
 998                                exception = 1;
 999                        }
1000                }




      ____________________________________________________________________________________
You rock. That's why Blockbuster's offering you one month of Blockbuster Total Access, No Cost.  
http://tc.deals.yahoo.com/tc/blockbuster/text5.com
