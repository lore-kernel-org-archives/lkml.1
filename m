Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZLDXfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZLDXfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 18:35:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932441AbZLDXfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 18:35:06 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:44276 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932442AbZLDXfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 18:35:05 -0500
Date: Fri, 4 Dec 2009 15:34:39 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: mmotm 2009-12-03-22-57 uploaded (isdn: proc_fops)
Message-Id: <20091204153439.2c1da767.randy.dunlap@oracle.com>
In-Reply-To: <200912040703.nB47324P028370@imap1.linux-foundation.org>
References: <200912040703.nB47324P028370@imap1.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B199CA3.00D1:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Dec 2009 23:03:02 -0800 akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2009-12-03-22-57 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git
> 
> It contains the following patches against 2.6.32:

> proc_fops-convert-drivers-isdn-to-seq_file.patch
> proc_fops-convert-drivers-isdn-to-seq_file-fix.patch


when CONFIG_PROC_FS=n:

drivers/isdn/gigaset/capi.c:2206: error: implicit declaration of function 'PDE'
drivers/isdn/gigaset/capi.c:2206: error: invalid type argument of '->'


when CONFIG_PROC_FS=y:

drivers/isdn/hysdn/hycapi.c:469: error: implicit declaration of function 'PDE'
drivers/isdn/hysdn/hycapi.c:469: error: invalid type argument of '->'
drivers/isdn/hysdn/hycapi.c:472: error: variable 'hycapi_proc_fops' has initializer but incomplete type
drivers/isdn/hysdn/hycapi.c:473: error: unknown field 'owner' specified in initializer
drivers/isdn/hysdn/hycapi.c:473: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:473: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:474: error: unknown field 'open' specified in initializer
drivers/isdn/hysdn/hycapi.c:474: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:474: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:475: error: unknown field 'read' specified in initializer
drivers/isdn/hysdn/hycapi.c:475: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:475: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:476: error: unknown field 'llseek' specified in initializer
drivers/isdn/hysdn/hycapi.c:476: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:476: warning: (near initialization for 'hycapi_proc_fops')
drivers/isdn/hysdn/hycapi.c:477: error: unknown field 'release' specified in initializer
drivers/isdn/hysdn/hycapi.c:477: warning: excess elements in struct initializer
drivers/isdn/hysdn/hycapi.c:477: warning: (near initialization for 'hycapi_proc_fops')

Needs to #include <linux/proc_fs.h>


---
~Randy
