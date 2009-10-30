Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZJ3ByF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZJ3ByF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:54:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756418AbZJ3ByE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:54:04 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36492 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873AbZJ3ByD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:54:03 -0400
Message-ID: <4AEA474B.8060904@np.css.fujitsu.com>
Date: Fri, 30 Oct 2009 10:54:19 +0900
From: Jin Dongming <jin.dongming@np.css.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Mimi Zohar <zohar@us.ibm.com>
CC: LKLM <linux-kernel@vger.kernel.org>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@redhat.com>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [BUG? -next] Compile tpm driver as module
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we compiled tpm driver as module in the next-tree, some errors happened.
The output error messages is showed as following:
    drivers/char/tpm/tpm.c:719: error: redefinition of ‘tpm_pcr_read’
    include/linux/tpm.h:35: note: previous definition of ‘tpm_pcr_read’ was here
    drivers/char/tpm/tpm.c:751: error: redefinition of ‘tpm_pcr_extend’
    include/linux/tpm.h:38: note: previous definition of ‘tpm_pcr_extend’ was here
    make[3]: *** [drivers/char/tpm/tpm.o] Error 1

The information of .config:
    CONFIG_TCG_TPM=m

Though I don't know the real reason, I found that the following patch caused
the problem.
    commit d6ba452128178091dab7a04d54f7e66fdc32fb39
    title: tpm add default function definitions

Best regards,
Jin Dongming

