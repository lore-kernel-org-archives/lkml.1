Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbZLQGEZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbZLQGEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 01:04:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbZLQGET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 01:04:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33169 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbZLQGES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 01:04:18 -0500
Message-ID: <4B29C81E.2000704@zytor.com>
Date: Wed, 16 Dec 2009 21:56:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>
CC: Roland Dreier <rdreier@cisco.com>, Masami Hiramatsu <mhiramat@redhat.com>,
       Andrew Isaacson <adi@vmware.com>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, Rob Landley <rob@landley.net>
Subject: Re: CONFIG_KPROBES=y build requires gawk
References: <20091216235617.GA12267@hexapodia.org> <adabphy750b.fsf@roland-alpha.cisco.com> <4B29A686.9070603@redhat.com> <ada3a3a6xs6.fsf@roland-alpha.cisco.com> <4B29BA13.7020502@redhat.com> <aday6l25gnm.fsf@roland-alpha.cisco.com> <20091217054524.GA3931@merkur.ravnborg.org>
In-Reply-To: <20091217054524.GA3931@merkur.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2009 09:45 PM, Sam Ravnborg wrote:
>>
>> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
>> index 45b20e4..0c46d60 100644
>> --- a/arch/x86/lib/Makefile
>> +++ b/arch/x86/lib/Makefile
>> @@ -5,7 +5,7 @@
>>  inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
>>  inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
>>  quiet_cmd_inat_tables = GEN     $@
>> -      cmd_inat_tables = $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
>> +      cmd_inat_tables = LC_ALL=C $(AWK) -f $(inat_tables_script) $(inat_tables_maps) > $@ || rm -f $@
> 
> This will result in error messages in english always from awk - no?
> Some people will care.
> 

True, we probably don't want to set LC_MESSAGES.  Which means:

diff --git a/Makefile b/Makefile
index 33d4732..357e83b 100644
--- a/Makefile
+++ b/Makefile
@@ -302,6 +302,13 @@ MAKEFLAGS += --include-dir=$(srctree)
 $(srctree)/scripts/Kbuild.include: ;
 include $(srctree)/scripts/Kbuild.include

+# Avoid funny character set dependencies
+LC_ALL=
+LC_CTYPE=C
+LC_COLLATE=C
+LC_NUMERIC=C
+export LC_ALL LC_CTYPE LC_COLLATE LC_NUMERIC
+
 # Make variables (CC, etc...)

 AS		= $(CROSS_COMPILE)as


OK?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

