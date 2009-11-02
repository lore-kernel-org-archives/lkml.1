Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbZKBOPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbZKBOPO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 09:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZKBOPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 09:15:13 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:46240 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043AbZKBOPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 09:15:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Xlip2lSHgwBdzSe27ABpkC5ABTZxIFLZk/YaX6MN8BdroTGFEE/0zqhS1Uhml+vyhE
         ExKZPAbsLGWydis04RvZ7ZN58jRYUwzt+jCmgu7dZfQMKoRmVqdRDyRyXOuzxnHtYN15
         D2IBhyDGf1SwpM7XAJ8b2MNu+rI/eebNSPUqk=
Date: Mon, 2 Nov 2009 15:15:15 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Robin Getz <rgetz@analog.com>, Dave Young <hidave.darkstar@gmail.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] SGI x86_64 UV: Add limit console output function
Message-ID: <20091102141511.GE4878@nowhere>
References: <20091023233743.439628000@alcatraz.americas.sgi.com> <20091023233746.128967000@alcatraz.americas.sgi.com> <20091024010906.GA4938@nowhere> <4AE5E293.6090703@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AE5E293.6090703@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 26, 2009 at 10:55:31AM -0700, Mike Travis wrote:
>
>
> Frederic Weisbecker wrote:
>> On Fri, Oct 23, 2009 at 06:37:44PM -0500, Mike Travis wrote:
>>> With a large number of processors in a system there is an excessive amount
>>> of messages sent to the system console.  It's estimated that with 4096
>>> processors in a system, and the console baudrate set to 56K, the startup
>>> messages will take about 84 minutes to clear the serial port.
>>>
>>> This patch adds (for SGI UV only) a kernel start option "limit_console_
>>> output" (or 'lco' for short), which when set provides the ability to
>>> temporarily reduce the console loglevel during system startup.  This allows
>>> informative messages to still be seen on the console without producing
>>> excessive amounts of repetious messages.
>>>
>>> Note that all the messages are still available in the kernel log buffer.
>>
>>
>>
>> Well, this problem does not only concerns SGI UV but all boxes with a large
>> number of cpus.
>>
>> Also, instead of adding the same conditionals in multiple places to solve
>> the same problem (and that may even expand if we go further the SGI UV case,
>> for example with other archs cpu up/down events), may be can you centralize,
>> institutionalize this issue by using the existing printk mechanisms.
>>
>> I mean, may be that could be addressed by adding a new printk
>> level flag, and then associate the desired filters against it.
>>
>> KERN_CPU could be a name, since this is targetting cpu events.
>>
>
> I did try out something like this but the changes quickly became very intrusive,
> and I was hoping for a "lighter" touch.  The other potential fallout of adding
> another printk level might affect user programs that sift through the dmesg
> log for "interesting" info.
>
> Also, I could use some other config option to enable this, it's just that the
> existing X86_UV was too convenient.  ;-)  I believe most systems would want this
> turned off so the code size shrinks.  And until you get the number of cpus into
> the hundreds and thousands, the messages usually just fly by - particularly if
> you're on a desktop system which has almost an infinite baud rate to the screen,
> and usually hides the messages behind a splash screen anyways.


Ok :)

