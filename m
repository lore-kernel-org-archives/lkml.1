Return-Path: <linux-kernel-owner+w=401wt.eu-S932493AbZACSsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493AbZACSsx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 13:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758904AbZACSsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 13:48:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.189]:53228 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758704AbZACSsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 13:48:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=xJI28PfVgGiwJht9eVN1+asi9TzhrAR33B3Qgccoqj49O8nPJxgdescRyxgKzmIgRN
         TtBqHa17b6eTbaG+nUZDUu5lbAJ2d3td5PCxZM8KIfJ4Bebm/oC3VgF3KfXBv4Ru5+Fn
         4DNYOV1vTe7Q1hGEIsmOZ8S3Szrt7BJFnpcec=
Message-ID: <517f3f820901031048p36e65f92l20bb7250cc4d82e5@mail.gmail.com>
Date: Sun, 4 Jan 2009 07:48:39 +1300
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Jason Baron" <jbaron@redhat.com>
Subject: Re: dynamic_printk documentation
Cc: "Tilman Schmidt" <t.schmidt@phoenixsoftware.de>,
       linux-kernel@vger.kernel.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>
In-Reply-To: <20081223162229.GB4126@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4950D8B5.5040404@phoenixsoftware.de>
	 <20081223162229.GB4126@redhat.com>
X-Google-Sender-Auth: e20ed2d884fddce4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 5:22 AM, Jason Baron <jbaron@redhat.com> wrote:
> On Tue, Dec 23, 2008 at 01:25:25PM +0100, Tilman Schmidt wrote:
>> Where is the current debugfs interface to dynamic_printk documented?
>> From the source in lib/dynamic_printk.c I deduced that
>>
>> echo "set enable=1 <module_name>" > /sys/kernel/debug/dynamic_printk/modules
>>
>> should enable debug output for module <module_name>, and verified
>> experimentally that this does indeed work. Is that already described
>> somewhere I just overlooked? If not, I would propose creating a file
>> Documentation/dynamic_printk.txt.
>>
>> Thanks,
>> Tilman
>
> hi,
>
> Most of it is with the config parameter definition in lib/Kconfig.debug
> (copied below). I can propose copying it into Documentation/ if you think it'd
> be useful.

That would make some sense.  Kconfig isn't usually the place where
where one expects to look for usage documentation.

Cheers,

Michael

> config DYNAMIC_PRINTK_DEBUG
>        bool "Enable dynamic printk() call support"
>        default n
>        depends on PRINTK
>        select PRINTK_DEBUG
>        help
>
>          Compiles debug level messages into the kernel, which would not
>          otherwise be available at runtime. These messages can then be
>          enabled/disabled on a per module basis. This mechanism implicitly
>          enables all pr_debug() and dev_dbg() calls. The impact of this
>          compile option is a larger kernel text size of about 2%.
>
>          Usage:
>
>          Dynamic debugging is controlled by the debugfs file,
>          dynamic_printk/modules. This file contains a list of the modules that
>          can be enabled. The format of the file is the module name, followed
>          by a set of flags that can be enabled. The first flag is always the
>          'enabled' flag. For example:
>
>                <module_name> <enabled=0/1>
>                                .
>                                .
>                                .
>
>          <module_name> : Name of the module in which the debug call resides
>          <enabled=0/1> : whether the messages are enabled or not
>
>          From a live system:
>
>                snd_hda_intel enabled=0
>                fixup enabled=0
>                driver enabled=0
>
>          Enable a module:
>
>                $echo "set enabled=1 <module_name>" > dynamic_printk/modules
>
>          Disable a module:
>
>                $echo "set enabled=0 <module_name>" > dynamic_printk/modules
>
>          Enable all modules:
>
>                $echo "set enabled=1 all" > dynamic_printk/modules
>
>          Disable all modules:
>
>                $echo "set enabled=0 all" > dynamic_printk/modules
>
>          Finally, passing "dynamic_printk" at the command line enables
>          debugging for all modules. This mode can be turned off via the above
>          disable command.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
