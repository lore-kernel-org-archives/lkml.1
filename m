Return-Path: <linux-kernel-owner+w=401wt.eu-S1762412AbZAOIHL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762412AbZAOIHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 03:07:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZAOIG4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 03:06:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:18884 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848AbZAOIGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 03:06:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,268,1231142400"; 
   d="scan'208";a="100220838"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Cyrill Gorcunov <gorcunov@gmail.com>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "harvey.harrison@gmail.com" <harvey.harrison@gmail.com>,
       "sam@ravnborg.org" <sam@ravnborg.org>,
       "jaswinderrajput@gmail.com" <jaswinderrajput@gmail.com>,
       Cyrill Gorcunov <gorcunov@openvz.org>
Date: Thu, 15 Jan 2009 08:06:31 +0000
Subject: RE: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Thread-Topic: [patch 3/5] x86: headers cleanup - ptrace-abi.h
Thread-Index: Acl2lnoW0Cau4qF5RICeFWRlZBCZiQAUOBGw
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77E0CD9CD33@irsmsx504.ger.corp.intel.com>
References: <20090114203745.285473388@gmail.com>>
 <496e4e23.0c07560a.5e4e.529c@mx.google.com> <496E6585.8050505@zytor.com>
In-Reply-To: <496E6585.8050505@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>-----Original Message-----
>From: H. Peter Anvin [mailto:hpa@zytor.com]
>Sent: Wednesday, January 14, 2009 11:22 PM
>To: Cyrill Gorcunov; Metzger, Markus T
>Cc: mingo@elte.hu; linux-kernel@vger.kernel.org; harvey.harrison@gmail.com; sam@ravnborg.org;
>jaswinderrajput@gmail.com; Cyrill Gorcunov
>Subject: Re: [patch 3/5] x86: headers cleanup - ptrace-abi.h
>
>Okay, this one really looks wrong to me.
>
>Markus, could you confirm if this was ever intended to be exported to
>userspace?  I suspect The Right Thing is simply to remove the #ifdef
>CONFIG_X86_TRACE_BTS here...

This is intended for userspace.
I added the #ifdef so the entire feature could be turned off.
This might not be necessary for declarations and macros, though.

Do you want me to remove the #ifdef CONFIG around the declarations in ptrace headers?

regards,
markus.

>
>	-hpa
>
>
>Cyrill Gorcunov wrote:
>> Impact: cleanup
>>
>> 'make headers_check' warn us about leaking of kernel private
>> (mostly compile time vars) data to userspace in headers. Fix it.
>>
>> ptrace_bts_config struct is wrapped by __KERNEL__ --
>> not sure if it was ever proposed for userland. On the
>> other hand branch tracing is really anxious for userland
>> developers.
>>
>> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
>> ---
>>  arch/x86/include/asm/ptrace-abi.h |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> Index: linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
>> ===================================================================
>> --- linux-2.6.git.orig/arch/x86/include/asm/ptrace-abi.h
>> +++ linux-2.6.git/arch/x86/include/asm/ptrace-abi.h
>> @@ -50,7 +50,7 @@
>>  #define RSP 152
>>  #define SS 160
>>  #define ARGOFFSET R11
>> -#endif /* __ASSEMBLY__ */
>> +#endif /* __ASSEMBLY__ || __FRAME_OFFSETS */
>>
>>  /* top of stack page */
>>  #define FRAME_SIZE 168
>> @@ -80,6 +80,7 @@
>>
>>  #define PTRACE_SINGLEBLOCK	33	/* resume execution until next branch */
>>
>> +#ifdef __KERNEL__
>>  #ifdef CONFIG_X86_PTRACE_BTS
>>
>>  #ifndef __ASSEMBLY__
>> @@ -141,5 +142,6 @@ struct ptrace_bts_config {
>>     Returns number of BTS records drained.
>>  */
>>  #endif /* CONFIG_X86_PTRACE_BTS */
>> +#endif /* __KERNEL__ */
>>
>>  #endif /* _ASM_X86_PTRACE_ABI_H */
>>
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

