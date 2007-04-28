Return-Path: <linux-kernel-owner+w=401wt.eu-S1030686AbXD1EyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686AbXD1EyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 00:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965440AbXD1EyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 00:54:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.235]:14741 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965427AbXD1EyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 00:54:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=G5Qs/yn+Do+A3GQksw5k8bCmqo/FYzFrvnn+aiw6Qxa+AX8nHYyWeNn+To3JHYUlxXIchu1X2TTTKXqKjzN0nujZD65aLystQe+0zWNV+csgZIrtH6GPKREAfoxDugJlOUmLgIMXeFL7NCUl+fVmRLj6Iq29pWfrpZuSsqocaWs=
Message-ID: <4632D372.7020908@gmail.com>
Date: Sat, 28 Apr 2007 13:54:10 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Roland Dreier <rdreier@cisco.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: commit 45cd8d8e -- why?
References: <ada647hnrf8.fsf@cisco.com> <20070427214923.74c504d9.akpm@linux-foundation.org>
In-Reply-To: <20070427214923.74c504d9.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 27 Apr 2007 19:50:19 -0700 Roland Dreier <rdreier@cisco.com> wrote:
> 
>> The changelog says:
>>
>>     fs/sysfs/bin.c: In function 'read':
>>     fs/sysfs/bin.c:77: warning: format '%zd' expects type 'signed size_t', but argument 4 has type 'int'
>>
>> but the signature of the function read() is
>>
>>     read(struct file * file, char __user * userbuf, size_t count, loff_t * off)
>>
>> and git blame seems to show it was always thus -- ie count was always size_t.
>>
>> And now on x86-64 and ia64 with gcc 4.1 at least, I get:
>>
>>     fs/sysfs/bin.c: In function 'read':
>>     fs/sysfs/bin.c:62: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> 
> Some patches landed out of order.  In Greg's tree (with Tejun's patches)
> `count' is a local variable (not an incoming arg) of type `int'.
> 
> So this patch was against Tejun's stuff, not against mainline.
> 
> I'd have picked that up, but I went and assumed that it was a victim of the
> new dev_dbg() printk arg checking stuff.  Ho hum.

Ah.. I already have this fix merged in my patch series.  I'm currently
testing things, so please be patient a little bit more.  Thanks.

-- 
tejun
