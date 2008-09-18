Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbYIRQ1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbYIRQ1o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYIRQ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:27:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37169 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754749AbYIRQ1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:27:33 -0400
Date: Thu, 18 Sep 2008 12:27:29 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: "Giacomo A. Catenazzi" <cate@cateee.net>
cc: Takashi Iwai <tiwai@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: diet-kconfig: a script to trim unneeded kconfigs
In-Reply-To: <48D27734.3040600@cateee.net>
Message-ID: <alpine.LFD.1.10.0809181154020.12224@bombadil.infradead.org>
References: <s5hbpyny7bl.wl%tiwai@suse.de> <20080918122541.2c3c7b39@areia.chehab.org> <48D27734.3040600@cateee.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008, Giacomo A. Catenazzi wrote:

> Mauro Carvalho Chehab wrote:
>> Hi Takashi,
>> 
>> On Wed, 17 Sep 2008 01:55:26 +0200
>> Takashi Iwai <tiwai@suse.de> wrote:
>
>>> The script is VERY hackish.  I should have begun with perl or whatever
>>> better script language, but I chose bash and co.  So, don't expect
>>> much code quality.  I'm no script guy after all :)
>> 
>> Using just a shellscript and binutils seems to be better than using other
>> tools, since it allows the usage on minimal configured systems where the 
>> user
>> might not have perl or other scripting languages.
>
> But very slow,

I don't think that performance is a big issue here. I tested Takashi 
scripts on this old 1.5 GHz centrino one core notebook, and it runned in a 
few seconds. Kernel compilation with diet config took 30-40 mins. The 
additional time for the script didn't significantly increased the total 
time.

> complex and not enough powerful:

For sure a scripting language like perl is more appropriate.

> The tools should have extensive knowledge about Kconfig,
> and the CONFIG_ dependencies

Since CONFIG_ and their dependencies are constantly 
changing/adding/removing at kernel, the better would be to have a good 
Kconfig parsing, avoiding to have lots of "local knowledge" about symbols. 
The better model seems to be the one where subsystem maintainers don't 
need to take extra care for not breaking the tool when touching at 
Kconfig/Makefiles.

Also, it occured me that some drivers have "implicit" Kconfig dependencies 
inside that may limit its work. Looking on a random driver, just as an 
example, you have things like:

$ grep ifdef cpufreq_stats.c
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS
cpufreq_stats.c:#ifdef CONFIG_CPU_FREQ_STAT_DETAILS

So, I suspect that the script might also need to parse the selected files 
to seek for additional rules.

I'm not sure what to do after discovering such things: Assume the option 
that generates smaller code? Assume the option that generates the most 
complete code? Maybe the better would be to use the selected config 
profile as a hint for such symbols. If not found there, then ask user.

> it should handle a lot of
> structures (text/binary; line/record oriented; etc.), which
> it is not easy in shell (awk, od, sed with extended regexp are
> not core utilities).

True.

> So my suggestion is: do it in a high level language, to find and
> stabilize the design, and then integrate it in kconfig later (using
> C).

Seems a good approach to me.

-- 
Cheers,
Mauro
