Return-Path: <linux-kernel-owner+w=401wt.eu-S1755547AbZDWIzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbZDWIzl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZDWIzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:55:32 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38349 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZDWIzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:55:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CskTC/wGolM22fKITjXWGUqoXT8PqEBr/bTD0OCgwrF5OxFVFs4XpxNXTJosHyG8iS
         vLFk52bLu8njQC30lEG3cG6aHDLELriDxU+0Q9KpEXkLwGsRWw/HdFAR7HYKkOXbJsao
         Z3DkL9c+G756GRzXSGH3JRuqfik9WSxW+1L6E=
MIME-Version: 1.0
In-Reply-To: <20090423082704.GD599@elte.hu>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <1240439073.12721.23.camel@earth> <20090423082704.GD599@elte.hu>
Date: Thu, 23 Apr 2009 10:55:29 +0200
Message-ID: <b647ffbd0904230155t61578496pf75fb79e54def3a3@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/23 Ingo Molnar <mingo@elte.hu>:
>
> * Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:
>
>> Version 3
>>
>> diff with v.2
>>
>> - use smp_call_function_single() instead of work_on_cpu() as suggested by Ingo;
>> - add 'enum ucode_state' as return value of request_microcode_{fw,user}
>> - minor cleanups
>
> This version looks really nice structurally. What type of testing
> have you done on the patch, on what CPU type?

Quite limited testing. It looks like there is no newer ucode availble
for my dual-core Intel Core2 Duo (Thinkpad R60) so what I did is as
follows:

- change update_match_revision() in microcode_intel.c in a way that
allows loading of a ucode with a revision == the current revision
(rev. 0x57 in my case). From the POV of the microcode module it
nevertheless looks like an update;

- update via /dev/microcode (CONFIG_MICROCODE_OLD_INTERFACE) with a .dat file;

- suspend -> resume (reload of ucode via cpu-callbacks)

These tests worked for me.

Obviously, it'd be nice if more people could give it a try (e.g.
update with a firmware image and also on AMD - although the changes in
microcode_amd.c are quite straightforward).


p.s. argh... just noticed that the following line is redundant in
microcode_core.c (forgot to remove it)

+enum { UCODE_UPDATE_ERR, UCODE_UPDATE_OK, UCODE_UPDATE_NAVAIL };


>
> Thanks,
>
>        Ingo
>

-- 
Best regards,
Dmitry Adamushko
