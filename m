Return-Path: <linux-kernel-owner+w=401wt.eu-S1752270AbZIYLEb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbZIYLEb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 07:04:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZIYLEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 07:04:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:50399 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbZIYLE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 07:04:29 -0400
Message-ID: <4ABCA3BF.8060107@suse.cz>
Date: Fri, 25 Sep 2009 13:04:31 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: akpm@linux-foundation.org, linux-kbuild@vger.kernel.org,
       JBeulich@novell.com, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Feedback on "kbuild: generate modules.builtin"
References: <200909181949.n8IJnT4R019097@imap1.linux-foundation.org> <20090920132856.GA26845@merkur.ravnborg.org>
In-Reply-To: <20090920132856.GA26845@merkur.ravnborg.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg napsal(a):
> On Fri, Sep 18, 2009 at 12:49:29PM -0700, akpm@linux-foundation.org wrote:
>> From: Michal Marek <mmarek@suse.cz>
>>
>> To make it easier for tools like mkinitrd to detect whether a needed
>> module is missing or whether it is compiled into the kernel, install a
>> modules.builtin file listing all modules built into the kernel.  This is
>> done by generating an alternate config file with all tristate =y options
>> set to =Y and reading the makefiles with this config included.  The built
>> in modules then appear in obj-Y.
> 
> Hi Michael.
> 
> [Added Steven on cc: as he had done some kconfig
>  hacking lately].
> 
> Got some time (finally) to look at this.
> I understand the functionality and I have myself had the need
> to see builtin modules.

Hi Sam,

many thanks for the review and for the patch, I basically agree with all
what you said, except this one:

>> diff -puN Makefile~kbuild-generate-modulesbuiltin Makefile
>> --- a/Makefile~kbuild-generate-modulesbuiltin
>> +++ a/Makefile
>> @@ -871,6 +871,9 @@ $(sort $(vmlinux-init) $(vmlinux-main)) 
>>  PHONY += $(vmlinux-dirs)
>>  $(vmlinux-dirs): prepare scripts
>>  	$(Q)$(MAKE) $(build)=$@
>> +ifdef CONFIG_MODULES
>> +	$(Q)$(MAKE) $(modbuiltin)=$@
>> +endif
> 
> The other stuff we run after a completed build is the
> target vmlinux: just above.
> If there is no good reason not to do so please move
> it so we keep all these post processing steps in one place.

The reason is that I need to iterate over $(vmlinux-dirs) to descend
into subdirectories like Makefile.build does. Putting the command here
allows to just write $(MAKE) $(modbuiltin)=$@ and be done, in the
vmlinux target I would have to do the iteration manually.

I'll provide an updated patch soon.

Michal
