Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYJIB2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYJIB2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 21:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbYJIB2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 21:28:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:40884 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbYJIB2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 21:28:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=UPhShjd2OJIKVgsF8X3iE6kPTo74e0AjW5alO807+mMBWqfdpjsUlbtT8TkyuGVr57
         UQxCck+4jjcgxVEketcyCd9Ys4U+wEAqVgJTMPDofH5RlPO/v2f9D0yCLgKUyfcCowCL
         J2zp1BCrxmq0GafJr+rf7iYKLbHj/wzbIM+Mw=
Message-ID: <86802c440810081828m2b9210e6y81503bdffe12fb03@mail.gmail.com>
Date: Wed, 8 Oct 2008 18:28:39 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Randy Dunlap" <rdunlap@xenotime.net>
Subject: Re: [PATCH 1/3] x86: mtrr_cleanup update command line
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081008170751.6d86b8e2.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222817380-29481-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080930165739.7847be37.rdunlap@xenotime.net>
	 <20081008170751.6d86b8e2.rdunlap@xenotime.net>
X-Google-Sender-Auth: 04bbf1c9243e27c7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2008 at 5:07 PM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 30 Sep 2008 16:57:39 -0700 Randy Dunlap wrote:
>
> BTW, this comment is alread in Documentation/kernel-parameters.txt, at the top of the file:

oh...

>
> The following is a consolidated list of the kernel parameters as implemented
> (mostly) by the __setup() macro and sorted into English Dictionary order
> (defined as ignoring all punctuation and sorting digits before letters in a
> case insensitive manner), and with descriptions where known.
>
>
how about

like to filter out disable, enable, no, etc...

diff --git a/Documentation/kernel-parameters.txt
b/Documentation/kernel-parameters.txt
index 4b9ee9b..782e2b0 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -620,35 +620,6 @@ and is between 256 and 4096 characters. It is
defined in the file
                        See drivers/char/README.epca and
                        Documentation/digiepca.txt.

-       disable_mtrr_cleanup [X86]
-       enable_mtrr_cleanup [X86]
-                       The kernel tries to adjust MTRR layout from continuous
-                       to discrete, to make X server driver able to add WB
-                       entry later. This parameter enables/disables that.
-
-       mtrr_chunk_size=nn[KMG] [X86]
-                       used for mtrr cleanup. It is largest continous chunk
-                       that could hold holes aka. UC entries.
-
-       mtrr_gran_size=nn[KMG] [X86]
-                       Used for mtrr cleanup. It is granularity of mtrr block.
-                       Default is 1.
-                       Large value could prevent small alignment from
-                       using up MTRRs.
-
-       mtrr_spare_reg_nr=n [X86]
-                       Format: <integer>
-                       Range: 0,7 : spare reg number
-                       Default : 1
-                       Used for mtrr cleanup. It is spare mtrr entries number.
-                       Set to 2 or more if your graphical card needs more.
-
-       disable_mtrr_trim [X86, Intel and AMD only]
-                       By default the kernel will trim any uncacheable
-                       memory out of your available memory pool based on
-                       MTRR settings.  This parameter disables that behavior,
-                       possibly causing your machine to run very slowly.
-
        dmasound=       [HW,OSS] Sound subsystem buffers

        dscc4.setup=    [NET]
@@ -1310,6 +1281,35 @@ and is between 256 and 4096 characters. It is
defined in the file
                        [HW] Make the MicroTouch USB driver use raw coordinates
                        ('y', default) or cooked coordinates ('n')

+       disable_mtrr_cleanup [X86]
+       enable_mtrr_cleanup [X86]
+                       The kernel tries to adjust MTRR layout from continuous
+                       to discrete, to make X server driver able to add WB
+                       entry later. This parameter enables/disables that.
+
+       mtrr_chunk_size=nn[KMG] [X86]
+                       used for mtrr cleanup. It is largest continous chunk
+                       that could hold holes aka. UC entries.
+
+       mtrr_gran_size=nn[KMG] [X86]
+                       Used for mtrr cleanup. It is granularity of mtrr block.
+                       Default is 1.
+                       Large value could prevent small alignment from
+                       using up MTRRs.
+
+       mtrr_spare_reg_nr=n [X86]
+                       Format: <integer>
+                       Range: 0,7 : spare reg number
+                       Default : 1
+                       Used for mtrr cleanup. It is spare mtrr entries number.
+                       Set to 2 or more if your graphical card needs more.
+
+       disable_mtrr_trim [X86, Intel and AMD only]
+                       By default the kernel will trim any uncacheable
+                       memory out of your available memory pool based on
+                       MTRR settings.  This parameter disables that behavior,
+                       possibly causing your machine to run very slowly.
+
        n2=             [NET] SDL Inc. RISCom/N2 synchronous serial card

        NCR_D700=       [HW,SCSI]
