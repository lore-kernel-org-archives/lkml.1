Return-Path: <linux-kernel-owner+w=401wt.eu-S1758124AbZEGIIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758124AbZEGIIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 04:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZEGIIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 04:08:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:61889 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954AbZEGIIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 04:08:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HB9HipIOj3A328hvy3JhzhSJYOPXvyw6/Jxa2fOhGwB+mENEKVJ2Bqwcgmsm3ewI5O
         pyGAtFiAXzMPGN7l5vs/tiSfUbxJ8BQVd4A/ZOXOjbwJCxtzKyNQ24qGfUyZLVdO5Q3s
         PTClcljKMvFgLW+k6E1KknnUrwBTeUpaAUIzY=
MIME-Version: 1.0
In-Reply-To: <1241649022.7811.35.camel@earth>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
	 <1240439073.12721.23.camel@earth> <1241649022.7811.35.camel@earth>
Date: Thu, 7 May 2009 10:08:35 +0200
Message-ID: <b647ffbd0905070108l1f20c468r5efc1b106263f276@mail.gmail.com>
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
Content-Type: multipart/mixed; boundary=0016364c7a4dcdc2dd04694e043c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016364c7a4dcdc2dd04694e043c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

2009/5/7 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> CC: Hugh Dickins <hugh@veritas.com>
> CC: Rusty Russell <rusty@rustcorp.com.au>
> CC: Ingo Molnar <mingo@elte.hu>
> CC: Andreas Herrmann <andreas.herrmann3@amd.com>
> CC: Peter Oruba <peter.oruba@amd.com>
> CC: Arjan van de Ven <arjan@infradead.org>
>
>  arch/x86/include/asm/microcode.h  |   19 ++-
>  arch/x86/kernel/microcode_amd.c   |   58 +++-----
>  arch/x86/kernel/microcode_core.c  |  275 ++++++++++++++++++++++---------------
>  arch/x86/kernel/microcode_intel.c |   92 +++++--------
>  4 files changed, 234 insertions(+), 210 deletions(-)
>
> (there are ~20 new comment lines)

My fault, I forgot to remove a minor debuging trick.
The previous patch should be accompanied by the following.

Andreas, any chance you could give it a try with AMD setups? TIA.


(non-white-space-damaged version is enclosed)

--- arch/x86/kernel/microcode_intel-orig.c      2009-05-07
09:57:00.000000000 +0200
+++ arch/x86/kernel/microcode_intel.c   2009-05-07 09:57:47.000000000 +0200
@@ -179,7 +179,7 @@ static inline int update_match_cpu(struc
 static inline int
 update_match_revision(struct microcode_header_intel *mc_header, int rev)
 {
-       return (mc_header->rev < rev) ? 0 : 1;
+       return (mc_header->rev <= rev) ? 0 : 1;
 }

 static int microcode_sanity_check(void *mc)



-- 
Best regards,
Dmitry Adamushko

--0016364c7a4dcdc2dd04694e043c
Content-Type: text/x-patch; charset=US-ASCII; name="microcode-rework-fix.patch"
Content-Disposition: attachment; filename="microcode-rework-fix.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fuf64l560

LS0tIGFyY2gveDg2L2tlcm5lbC9taWNyb2NvZGVfaW50ZWwtb3JpZy5jCTIwMDktMDUtMDcgMDk6
NTc6MDAuMDAwMDAwMDAwICswMjAwCisrKyBhcmNoL3g4Ni9rZXJuZWwvbWljcm9jb2RlX2ludGVs
LmMJMjAwOS0wNS0wNyAwOTo1Nzo0Ny4wMDAwMDAwMDAgKzAyMDAKQEAgLTE3OSw3ICsxNzksNyBA
QCBzdGF0aWMgaW5saW5lIGludCB1cGRhdGVfbWF0Y2hfY3B1KHN0cnVjCiBzdGF0aWMgaW5saW5l
IGludAogdXBkYXRlX21hdGNoX3JldmlzaW9uKHN0cnVjdCBtaWNyb2NvZGVfaGVhZGVyX2ludGVs
ICptY19oZWFkZXIsIGludCByZXYpCiB7Ci0JcmV0dXJuIChtY19oZWFkZXItPnJldiA8IHJldikg
PyAwIDogMTsKKwlyZXR1cm4gKG1jX2hlYWRlci0+cmV2IDw9IHJldikgPyAwIDogMTsKIH0KIAog
c3RhdGljIGludCBtaWNyb2NvZGVfc2FuaXR5X2NoZWNrKHZvaWQgKm1jKQo=
--0016364c7a4dcdc2dd04694e043c--
