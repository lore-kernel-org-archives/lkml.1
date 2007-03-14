Return-Path: <linux-kernel-owner+w=401wt.eu-S1161113AbXCNKsc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113AbXCNKsc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 06:48:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161095AbXCNKsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 06:48:32 -0400
Received: from wx-out-0506.google.com ([66.249.82.224]:22390 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161113AbXCNKsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 06:48:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JDxPLt2acdnP3mCyGRVwVLarBDtXg+U4C943KdlAwlCijevezFbkJQL8JhQGmg8FDJ+DPm5bSKK93Aa+dBfxouvKD8qkFR3vOKMJ/OAWxxChN9qJXKvyCx0peuBpdiH0NwEoA0neO3ioigN+Cpzkb3bd8YHFycxUKvidBHF9fn4=
Message-ID: <b6fcc0a0703140348o18a4b24fye3dcbad593cf83a5@mail.gmail.com>
Date: Wed, 14 Mar 2007 12:48:30 +0200
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 58/59] sysctl: Reimplement the sysctl proc support
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Adrian Bunk" <bunk@stusta.de>,
       "Alexander Viro" <viro@ftp.linux.org.uk>
In-Reply-To: <20070314103832.GA16104@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <m1ac0jc4no.fsf@ebiederm.dsl.xmission.com>
	 <11689657073389-git-send-email-ebiederm@xmission.com>
	 <20070314103832.GA16104@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/14/07, Ingo Molnar <mingo@elte.hu> wrote:
>  #define PROCNAME_PML    "sys/kernel/preempt_max_latency"
>
>  static __init int latency_fs_init(void)
>  {
>          struct proc_dir_entry *entry;
>
>          if (!(entry = create_proc_entry(PROCNAME_PML, 0644, NULL)))
>                  printk("latency_fs_init(): can't create %s\n",
> PROCNAME_PML);
>
> with your change that broke because beyond /proc/sys/ there are no real
> proc entries anymore, there's no de->subdir directory for
> xlate_proc_name() to find. While the latency tracer isnt upstream, this
> change in semantics does not seem to be intended (the changelog is
> certainly silent about it).

Use register_sysctl_table() for sysctls.
