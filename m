Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZEHUTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZEHUTH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 16:19:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753140AbZEHUSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 16:18:55 -0400
Received: from mga10.intel.com ([192.55.52.92]:23275 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751678AbZEHUSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 16:18:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,318,1239001200"; 
   d="scan'208";a="688837498"
Message-ID: <4A0493B0.3090204@linux.intel.com>
Date: Fri, 08 May 2009 13:18:56 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: linux-kernel@vger.kernel.org, vgoyal@redhat.com, hbabu@us.ibm.com,
       kexec@lists.infradead.org, ying.huang@intel.com, mingo@elte.hu,
       tglx@linutronix.de, ebiederm@xmission.com,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/14] kbuild: allow compressors (gzip, bzip2, lzma) to
 take multiple inputs
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com> <1241735222-6640-6-git-send-email-hpa@linux.intel.com> <20090508074234.GD12808@uranus.ravnborg.org>
In-Reply-To: <20090508074234.GD12808@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>> diff --git a/scripts/bin_size b/scripts/bin_size
>> index 43e1b36..55f2161 100644
>> --- a/scripts/bin_size
>> +++ b/scripts/bin_size
>> @@ -1,10 +1,14 @@
>>  #!/bin/sh
>>  
>>  if [ $# = 0 ] ; then
>> -   echo Usage: $0 file
>> +   echo Usage: $0 file...
>>  fi
>>  
>> -size_dec=`stat -c "%s" $1`
>> +size_dec=0
>> +for file; do
>> +  fsize=`stat -c "%s" $file`
>> +  size_dec=`expr $size_dec + $fsize`
>> +done
>>  size_hex_echo_string=`printf "%08x" $size_dec |
>>       sed 's/\(..\)\(..\)\(..\)\(..\)/\\\\x\4\\\\x\3\\\\x\2\\\\x\1/g'`
>>  /bin/echo -ne $size_hex_echo_string
> 
> But I would rather have had this inside makefile.lib...
> 

It's messy enough as a shell script... it seems like baking it into 
Makefile syntax would make it even worse.

	-hpa

