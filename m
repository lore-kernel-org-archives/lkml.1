Return-Path: <linux-kernel-owner+w=401wt.eu-S1754922AbZKMB2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754922AbZKMB2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 20:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754746AbZKMB2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 20:28:13 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:63565 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754642AbZKMB2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 20:28:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:content-type;
        b=JeaObg2J8MJV25OBHglAuW+8ELOgdqvAmg+dCl4xY/il1Ya+8frupMJhH5MfCr8nDx
         SG5Ef46WptSQke8jwK+nnto03tVrAHSJNQ0wMro3V7eWy5+CM4n/IrSGwB7KvEaKw0aE
         99OpV7lE2LgyVlCbZE4CbGydnkB7Z+MbgZ0dk=
MIME-Version: 1.0
Date: Thu, 12 Nov 2009 18:28:18 -0700
X-Google-Sender-Auth: beafb2e054473ddb
Message-ID: <e9c3a7c20911121728n647ab121l7f7c5827afdac887@mail.gmail.com>
Subject: GFP_ATOMIC versus GFP_NOWAIT
From: Dan Williams <dan.j.williams@intel.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking through the tree it seems that almost all drivers that need to
allocate memory in atomic contexts use GFP_ATOMIC.  I have been asking
dmaengine device driver authors to switch their atomic allocations to
GFP_NOWAIT.  The rationale being that in most cases a dma device is
either offloading an operation that will automatically fallback to
software when the descriptor allocation fails, or we can simply poll
and wait for the dma device to release some in use descriptors.  So it
does not make sense to grab from the emergency pools when the result
of an allocation failure is some additional cpu overhead.  Am I
correct in my nagging, and should this idea be spread outside of
drivers/dma/ to cut down on GFP_ATOMIC usage, or is this not a big
issue?

Thanks,
Dan
