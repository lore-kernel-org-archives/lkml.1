Return-Path: <linux-kernel-owner+w=401wt.eu-S1762511AbZD3WEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762511AbZD3WEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 18:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbZD3WEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 18:04:23 -0400
Received: from fk-out-0910.google.com ([209.85.128.190]:30012 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457AbZD3WEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 18:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XOegFWGBXLNrbDI/+qYP9t2BQhNRyFFy6rQLSash4aIG5ggHK2Vkzj7DsvHmqmXMnT
         QPTqlZEat/LUyz98Vls/o/aGDj7ZpnVTHAJ7ydt4kmL9/Le1xRyc1EHXBc052NsWX9Xu
         3y4E9w+r7kQbAIft0NgP2rgbs37+jGo9POw2w=
MIME-Version: 1.0
In-Reply-To: <20090430185223.792841532@goodmis.org>
References: <20090430185022.122124349@goodmis.org>
	 <20090430185223.792841532@goodmis.org>
Date: Thu, 30 Apr 2009 23:04:21 +0100
Message-ID: <9b2b86520904301504m2906e466ndd8b9e7851bcd59@mail.gmail.com>
Subject: Re: [PATCH 7/7] kconfig: search for a config to base the 
	local(mod|yes)config on
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/30/09, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> Instead of using the .config in the local directory. This patch
> changes streamline_config.pl to search various locations for a config.
>
> Here's the list and order of search:
>
>   /proc/config.gz
>   /boot/vmlinuz-`uname -r`
>   vmlinux  # local to the directory
>   /lib/modules/`uname -r`/kernel/kernel/configs.ko
>   kernel/configs.ko
>   kernel/configs.o
>   .config
>
> Once it finds a file that contains a config (it checks if the binary
> objects have configs first) it then uses it to create the .config
> with minimum modules needed.

Maybe this has already been discussed, but is there some reason for
omitting /boot/config-`uname -r`?  My understanding as a user of a
specific distribution was that kernel packages provide these files,
and therefore do not feel the need to enable CONFIG_IKCONFIG.

Regards
Alan
