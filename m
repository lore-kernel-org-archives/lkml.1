Return-Path: <linux-kernel-owner+w=401wt.eu-S1756229AbYHTTZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229AbYHTTZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 15:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752053AbYHTTZP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 15:25:15 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:28063 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982AbYHTTZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 15:25:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=x6yxs2CRDOpXQO8/NV02CkL5kBHAZsqaHdwqHU209VYT3ipBhOVG0pRNhIjp0DJ6R7
         7ATZml9iLoKWA2GSZUqKNrvYGVtMz2yOml+2idY43IMEXhaLEcyjBF7kQnUcZvz9TdZr
         zI5KecQY/cY9q0nbbBxjLDeDjUBF/3mDhWzM8=
Message-ID: <f6ca9fed0808201225p73a4303di3f806e8843c87f0a@mail.gmail.com>
Date: Wed, 20 Aug 2008 21:25:12 +0200
From: drago01 <drago01@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: [PATCH] Use EXPORT_SYMBOL for pv_lock_ops
Cc: "kernel list" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 7:06 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> drago01 wrote:
>> Hi,
>>
>> It seems that in 2.6.27 pv_lock_ops is now GPL only which breaks
>> binary drivers because they pick it up implicitly when CONFIG_PARAVIRT
>> is enabled.
>> (see http://www.nvnews.net/vbulletin/showpost.php?p=1750090&postcount=2)
>> Is there a reason for doing this?
>> As some other pv_* are exported to all modules can this be done for
>> this too? (there should be no difference between CONFIG_PARAVIRT on or
>> of for GPL'd symbols).
>
> Yeah, they're just GPL by default, but the lock code is not exported GPL
> so there's no reason why lock_ops should be.
>
>    J
>
>

Use EXPORT_SYMBOL for pv_lock_ops to preserve the behavior between
CONFIG_PARAVIRT set and unset.
Currently we only used _GPL when the non paravirt symbols are GPL only too.

Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

diff --git a/arch/x86/kernel/paravirt.c b/arch/x86/kernel/paravirt.c
index 94da4d5..300da17 100644
--- a/arch/x86/kernel/paravirt.c
+++ b/arch/x86/kernel/paravirt.c
@@ -471,7 +471,7 @@ struct pv_lock_ops pv_lock_ops = {
        .spin_unlock = __ticket_spin_unlock,
 #endif
 };
-EXPORT_SYMBOL_GPL(pv_lock_ops);
+EXPORT_SYMBOL(pv_lock_ops);

 EXPORT_SYMBOL_GPL(pv_time_ops);
 EXPORT_SYMBOL    (pv_cpu_ops);
