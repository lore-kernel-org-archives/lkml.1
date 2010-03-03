Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab0CCXhQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 18:37:16 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:23513 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab0CCXhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 18:37:12 -0500
Message-ID: <4B8EF231.60008@oracle.com>
Date: Wed, 03 Mar 2010 15:35:13 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH mmotm] xfs: needs LIST_SORT
References: <201003030305.o2335F1F015917@imap1.linux-foundation.org> <4B8EB545.8060806@oracle.com> <20100303232522.GC14317@discord.disaster>
In-Reply-To: <20100303232522.GC14317@discord.disaster>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B8EF289.0064:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/10 15:25, Dave Chinner wrote:
> On Wed, Mar 03, 2010 at 11:15:17AM -0800, Randy Dunlap wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> xfs uses list_sort (library function), so it needs to select it.
>> Fixes these build errors:
>> fs/xfs/linux-2.6/xfs_buf.c:1918: undefined reference to `list_sort'
>> fs/xfs/linux-2.6/xfs_buf.c:1996: undefined reference to `list_sort'
>> fs/xfs/linux-2.6/xfs_buf.c:1950: undefined reference to `list_sort'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  fs/xfs/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- mmotm-2010-0302-1838.orig/fs/xfs/Kconfig
>> +++ mmotm-2010-0302-1838/fs/xfs/Kconfig
>> @@ -2,6 +2,7 @@ config XFS_FS
>>  	tristate "XFS filesystem support"
>>  	depends on BLOCK
>>  	select EXPORTFS
>> +	select LIST_SORT
>>  	help
>>  	  XFS is a high performance journaling filesystem which originated
>>  	  on the SGI IRIX platform.  It is completely multi-threaded, can
> 
> Looks OK, but when and why did a config option get introduced for
> this?

no idea.

> I thought that Andi was trying to cull unused symbols in
> library functions automatically, so config options weren't needed...
> 
> FWIW, did UBIFS and DRM also get this select line added to them?

I just checked and both of those already select LIST_SORT.
(in -mmotm)

-- 
~Randy
