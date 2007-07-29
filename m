Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXG2Q2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXG2Q2h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 12:28:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763678AbXG2Q21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 12:28:27 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:2857 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765996AbXG2Q2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 12:28:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=qCS88UTSNs10IxQTnmk75cws9rPDvK95Z8e3qF1vQ1udM+I9rmNrMes7mMA/jtIItX6ktEPnl2THCoG1UBd8gCW0vBf0J3QpdcMxrPnb7Pp1TZlhhDZ/njNSjtEccP/9QvjSOA8TwdvvhF/NDezThb2PyIUgGgskGqam0ttxuEM=
Message-ID: <e9c3a7c20707290928r53bf2530ue02c5e1d4f03be46@mail.gmail.com>
Date: Sun, 29 Jul 2007 09:28:25 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: apw@shadowen.org, rdunlap@xenotime.net, jschopp@austin.ibm.com
Subject: checkpatch.pl false positive on exported pointers
Cc: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 0d365f24f9ffb598
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
#563: FILE: drivers/scsi/iioc34x/iioc34x_sas.c:58:
+EXPORT_SYMBOL(iioc34x_transport_template);

drivers/scsi/iioc34x/iioc34x_sas.c:57
struct scsi_transport_template *iioc34x_transport_template;
EXPORT_SYMBOL(iioc34x_transport_template);

I suspect the script wants:
EXPORT_SYMBOL(*iioc34x_transport_template);
...but that does not compile.

Thanks,
Dan
