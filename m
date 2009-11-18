Return-Path: <linux-kernel-owner+w=401wt.eu-S1756217AbZKRCpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217AbZKRCpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 21:45:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755015AbZKRCpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 21:45:52 -0500
Received: from mail-pz0-f171.google.com ([209.85.222.171]:64311 "EHLO
	mail-pz0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbZKRCpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 21:45:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JkyuqaWJGkPs1+u74aPYHgMZjCuMQpWRaaRiH2GFWt3XI1gumg/fubBNHRnniJJOWF
         tgsGbF69Ritb1loTikP++8srDhw/DB5uFLx0GvWeXcGKJ/s0PVljfRM8ewNCvj1tlK4z
         q+iJJ57+s5JL4Pkoap4cBx0FBAzWlcZoDTF1M=
MIME-Version: 1.0
In-Reply-To: <20091118002219.163869000@alcatraz.americas.sgi.com>
References: <20091118002211.709343000@alcatraz.americas.sgi.com>
	 <20091118002219.163869000@alcatraz.americas.sgi.com>
Date: Tue, 17 Nov 2009 18:45:57 -0800
Message-ID: <86802c440911171845v1dae0f27i78ee7347d0f315d0@mail.gmail.com>
Subject: Re: [PATCH 1/5] x86: Limit the number of processor bootup messages
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 4:22 PM, Mike Travis <travis@sgi.com> wrote:
> When there are a large number of processors in a system, there
> is an excessive amount of messages sent to the system console.
> It's estimated that with 4096 processors in a system, and the
> console baudrate set to 56K, the startup messages will take
> about 84 minutes to clear the serial port.
>
> This set of patches limits the number of repetitious messages
> which contain no additional information.  Much of this information
> is obtainable from the /proc and /sysfs.   Some of the messages
> are also sent to the kernel log buffer as KERN_DEBUG messages so
> dmesg can be used to examine more closely any details specific to
> a problem.
>
> The new cpu bootup sequence for system_state == SYSTEM_BOOTING:
>
> Booting Node   0, Processors  #1 #2 #3 #4 #5 #6 #7 Ok.
> Booting Node   1, Processors  #8 #9 #10 #11 #12 #13 #14 #15 Ok.
> ..
> Booting Node   3, Processors  #56 #57 #58 #59 #60 #61 #62 #63 Ok.
> Brought up 64 CPUs

how about
Booting Node   0, Processors  #1/0x01 #2/0x02 #3....
append apic id in hex after the numbering.?

YH
