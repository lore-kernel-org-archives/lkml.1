Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZJ0OIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZJ0OIm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:08:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbZJ0OIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:08:42 -0400
Received: from mail-px0-f180.google.com ([209.85.216.180]:45451 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918AbZJ0OIl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:08:41 -0400
MIME-Version: 1.0
In-Reply-To: <4AE5ACE3.30103@linux.vnet.ibm.com>
References: <1256563579-11014-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <4AE5ACE3.30103@linux.vnet.ibm.com>
Date: Tue, 27 Oct 2009 10:08:44 -0400
Message-ID: <7e0fb38c0910270708ue3619fage123c24893685189@mail.gmail.com>
Subject: Re: [PATCH] tpm add default function definitions
From: Eric Paris <eparis@parisplace.org>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       James Morris <jmorris@namei.org>,
       Jean-Christophe Dubois <jcd@tribudubois.net>,
       David Safford <safford@watson.ibm.com>, Mimi Zohar <zohar@us.ibm.com>,
       Stable Kernel <stable@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:06 AM, Rajiv Andrade
<srajiv@linux.vnet.ibm.com> wrote:
> Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>

I don't see this as stable material, but it looks good for -next.

Acked-by: Eric Paris <eparis@redhat.com>

>
> Mimi Zohar wrote:
>> Add default tpm_pcr_read/extend function definitions required
>> by IMA/Kconfig changes.
>>
>> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
>> Cc: Stable Kernel <stable@kernel.org>
>> ---
>>  include/linux/tpm.h |    7 +++++++
>>  1 files changed, 7 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/tpm.h b/include/linux/tpm.h
>> index 3338b3f..8eaa8f8 100644
>> --- a/include/linux/tpm.h
>> +++ b/include/linux/tpm.h
>> @@ -31,5 +31,12 @@
>>
>>  extern int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf);
>>  extern int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash);
>> +#else
>> +static inline int tpm_pcr_read(u32 chip_num, int pcr_idx, u8 *res_buf) {
>> +     return -ENODEV;
>> +}
>> +static inline int tpm_pcr_extend(u32 chip_num, int pcr_idx, const u8 *hash) {
>> +     return -ENODEV;
>> +}
>>  #endif
>>  #endif
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
