Return-Path: <linux-kernel-owner+w=401wt.eu-S1756006AbXLJNbz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756006AbXLJNbz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:31:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXLJNbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:31:48 -0500
Received: from swsoft-mipt-nat.sw.ru ([195.214.233.10]:63878 "EHLO iris"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751003AbXLJNbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:31:47 -0500
Message-ID: <475D3FE2.202@sw.ru>
Date: Mon, 10 Dec 2007 16:32:18 +0300
From: "Denis V. Lunev" <den@sw.ru>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, rjw@sisk.pl,
       trond.myklebust@fys.uio.no, gnome42@gmail.com,
       linux-kernel@vger.kernel.org, bfields@fieldses.org, den@openvz.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [PATCH 2.6.24-rc4] proc: Remove/Fix proc generic d_revalidate
References: <fa4052ef0712062045o743a2666u3562a3569c1aa989@mail.gmail.com>	<1197067918.10831.13.camel@heimdal.trondhjem.org>	<20071207151444.af5d8e11.akpm@linux-foundation.org>	<200712080043.29292.rjw@sisk.pl>	<20071208000043.GC1951@martell.zuzino.mipt.ru>	<20071207161508.afe8fdf1.akpm@linux-foundation.org> <m1lk85q0cw.fsf_-_@ebiederm.dsl.xmission.com> <475CA9EA.1090405@vc.cvut.cz>
In-Reply-To: <475CA9EA.1090405@vc.cvut.cz>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

could you, plz, check patch sent by Eric above in this thread.

I have tried it on my test node and it works for module you have
provided. The problem exists without it.

Regards,
	Den

Petr Vandrovec wrote:
> Eric W. Biederman wrote:
>> Ultimately to implement /proc perfectly we need an implementation
>> of d_revalidate because files and directories can be removed behind
>> the back of the VFS, and d_revalidate is the only way we can let
>> the VFS know that this has happened.
>>
>> So until we get a proper test for keeping dentries in the dcache
>> fix the current d_revalidate method by completely removing it.  This
>> returns us to the current status quo.
> 
> Hello,
>    I know that I'm late to the party, but mount points is not only
> problem with d_revalidate.  With your patch in place module below gets
> refcount incremented by two every time I do 'ls -la /proc/fs/vmblock'.
> 
> 
> #include <linux/kernel.h>
> #include <linux/module.h>
> #include <linux/proc_fs.h>
> 
> static int vmblockinit(void) {
>    struct proc_dir_entry *controlProcDirEntry;
> 
>    /* Create /proc/fs/vmblock */
>    controlProcDirEntry = proc_mkdir("vmblock", proc_root_fs);
>    if (!controlProcDirEntry) {
>       printk(KERN_DEBUG "Bad...\n");
>       return -EINVAL;
>    }
>    controlProcDirEntry->owner = THIS_MODULE;
>    return 0;
> }
> 
> static void vmblockexit(void) {
>    remove_proc_entry("vmblock", proc_root_fs);
> }
> 
> module_init(vmblockinit);
> module_exit(vmblockexit);
> 
> 
> (code comes from VMware's vmblock module,
> http://sourceforge.net/project/showfiles.php?group_id=204462)
>                         Thanks,
>                             Petr
> 
> 

