Return-Path: <linux-kernel-owner+w=401wt.eu-S1751612Ab0AGR3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0AGR3o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:29:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751422Ab0AGR3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:29:44 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:34330 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab0AGR3n convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:29:43 -0500
MIME-Version: 1.0
In-Reply-To: <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
References: <201001062259.o06MxQrp023236@imap1.linux-foundation.org>
	 <20100106170849.d0d95c9b.randy.dunlap@oracle.com>
	 <20100107113154.a1fa0103.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 7 Jan 2010 19:29:41 +0200
Message-ID: <cc557aab1001070929p32d50284jaac2cd5230559697@mail.gmail.com>
Subject: Re: mmotm 2010-01-06-14-34 uploaded (kernel/cgroup)
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 7, 2010 at 4:31 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 6 Jan 2010 17:08:49 -0800
> Randy Dunlap <randy.dunlap@oracle.com> wrote:
>
>> On Wed, 06 Jan 2010 14:34:36 -0800 akpm@linux-foundation.org wrote:
>>
>> > The mm-of-the-moment snapshot 2010-01-06-14-34 has been uploaded to
>> >
>> >    http://userweb.kernel.org/~akpm/mmotm/
>> >
>> > and will soon be available at
>> >
>> >    git://zen-kernel.org/kernel/mmotm.git
>> >
>> > It contains the following patches against 2.6.33-rc3:
>>
>>
>> kernel/cgroup.c: In function 'cgroup_write_event_control':
>> kernel/cgroup.c:2949: error: implicit declaration of function 'eventfd_fget'
>> kernel/cgroup.c:2949: warning: assignment makes pointer from integer without a cast
>> kernel/cgroup.c:2955: error: implicit declaration of function 'eventfd_ctx_fileget'
>> kernel/cgroup.c:2955: warning: assignment makes pointer from integer without a cast
>> make[2]: *** [kernel/cgroup.o] Error 1
>>
>
> Hmm, how about this rather than adding #ifdefs..
> Paul, Li, how do you think ?
> ==
> Cgroup's eventdf feature has depenedecy to EVENTFD
>
> This is a patch onto
> cgroup-implement-eventfd-based-generic-api-for-notifications.patch
>
> CC: Li Zefan <lizf@cn.fujitsu.com>
> CC: Kirill A. Shutemov <kirill@shutemov.name>
> CC: Paul Menage <menage@google.com>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> ---
>  init/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
>
> Index: ref-mmotm/init/Kconfig
> ===================================================================
> --- ref-mmotm.orig/init/Kconfig
> +++ ref-mmotm/init/Kconfig
> @@ -509,6 +509,7 @@ endchoice
>
>  menuconfig CGROUPS
>        boolean "Control Group support"
> +       depends on EVENTFD
>        help
>          This option adds support for grouping sets of processes together, for
>          use with process control subsystems such as Cpusets, CFS, memory
>
>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>
