Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbZEVTFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbZEVTFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 15:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756936AbZEVTE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 15:04:57 -0400
Received: from h155.mvista.com ([63.81.120.155]:41693 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751688AbZEVTE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 15:04:56 -0400
Message-ID: <4A16F78F.6060503@ru.mvista.com>
Date: Fri, 22 May 2009 23:05:51 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] ide: respect quirk_drives[] list on all controllers
References: <200905201734.42093.bzolnier@gmail.com> <4A15A7DD.1040300@ru.mvista.com> <200905222059.08161.bzolnier@gmail.com>
In-Reply-To: <200905222059.08161.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>>* Add ide_check_nien_quirk_list() helper to the core code
>>>  and then use it in ide_port_tune_devices().

>>>* Remove no longer needed ->quirkproc methods from hpt366.c
>>>  and pdc202xx_{new,old}.c.

>>    Haha, I remembered about that idea of yours and was thinking of 
>>undertaking its implementation just yesterday. You've beten me to it. :-)

> Sigh, if I knew I would concentrate on other things...

> I did it only because there is outstanding ide-pmac bugreport probably
> related to one of these quirky drives...

    Yes, I figured. :-)

>>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

>>Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

>>>Index: b/drivers/ide/ide-iops.c
>>>===================================================================
>>>--- a/drivers/ide/ide-iops.c
>>>+++ b/drivers/ide/ide-iops.c
>>>@@ -269,6 +269,31 @@ no_80w:
>>> 	return 0;
>>> }
>>> 
>>>+static const char *nien_quirk_list[] = {
>>>+	"QUANTUM FIREBALLlct08 08",
>>>+	"QUANTUM FIREBALLP KA6.4",
>>>+	"QUANTUM FIREBALLP KA9.1",
>>>+	"QUANTUM FIREBALLP KX13.6",
>>>+	"QUANTUM FIREBALLP KX20.5",
>>>+	"QUANTUM FIREBALLP KX27.3",
>>>+	"QUANTUM FIREBALLP LM20.4",
>>>+	"QUANTUM FIREBALLP LM20.5",
>>>+	NULL
>>>+};
>>>+
>>>+void ide_check_nien_quirk_list(ide_drive_t *drive)

>>    Why not reuse ide_in_drive_list()?

> Should have been in patch #5/4 but I ran out of time, I will do it later
> unless you would like to handle it...

    I'm looking at the unification of ack_intr()/clear_irq() now and making 
the former usable for the PCI drivers too...

MBR, Sergei
