Return-Path: <linux-kernel-owner+w=401wt.eu-S1755883AbYGVVhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883AbYGVVhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 17:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753778AbYGVVhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 17:37:06 -0400
Received: from mga01.intel.com ([192.55.52.88]:61566 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbYGVVhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 17:37:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,233,1215414000"; 
   d="scan'208";a="600085222"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] pci: proc.c sparse endian annotations
Date: Tue, 22 Jul 2008 14:37:01 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <1216335450.6029.45.camel@brick>
In-Reply-To: <1216335450.6029.45.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807221437.01847.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 17, 2008 3:57 pm Harvey Harrison wrote:
> drivers/pci/proc.c:91:3: warning: cast from restricted __le16
> drivers/pci/proc.c:100:3: warning: cast from restricted __le32
> drivers/pci/proc.c:109:3: warning: cast from restricted __le16
> drivers/pci/proc.c:161:40: warning: cast to restricted __le16
> drivers/pci/proc.c:170:41: warning: cast to restricted __le32
> drivers/pci/proc.c:179:40: warning: cast to restricted __le16
>
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> ---
> Patch against next-20080717
>
>  drivers/pci/proc.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)

Somehow this patch came across with htmlish junk in it, care to resend?

Thanks,
Jesse

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 7e2bd7e..c8eb11c 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -88,7 +88,7 @@ proc_bus_pci_read(struct file *file, char __user *buf, si=
ze_t nbytes, loff_t *pp
        if ((pos & 3) && cnt > 2) {
                unsigned short val;
                pci_user_read_config_word(dev, pos, &val);
-               __put_user(cpu_to_le16(val), (unsigned short __user *) buf)=
;
+               __put_user(cpu_to_le16(val), (__le16 __user *) buf);
