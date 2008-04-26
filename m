Return-Path: <linux-kernel-owner+w=401wt.eu-S1756720AbYDZVtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720AbYDZVtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 17:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbYDZVs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 17:48:57 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:40030 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140AbYDZVs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 17:48:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=w9eE6szDZS7QV3ucEriayQ0w20u3tIaY7AcX/Cf8ZtUb97pTxGMKEpEun7AkvXufS44BsIU0GhnLq9xEG0TYePvjSXpYcz8bvO7gh4sOjPYpvqffpMIWdqOu9+5DXV7kRYIhyJGHdYUUNOgMVbXxPqKXCiqb875eMstZcQFxU98=
Message-ID: <dd18b0c30804261448n128293e6s1149931726e95b36@mail.gmail.com>
Date: Sat, 26 Apr 2008 21:48:55 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Bob Copeland" <me@bobcopeland.com>
Subject: Re: spinlock lockup on CPU#0
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Venkatesh Pallipadi" <venkatesh.pallipadi@intel.com>
In-Reply-To: <b6c5339f0804261406o447b95b2i18c937a6c738f8db@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30804231841m3bbfab44x53d635b7ea6fc58d@mail.gmail.com>
	 <20080426112907.77613dee.akpm@linux-foundation.org>
	 <20080426191432.GA2927@elte.hu>
	 <b6c5339f0804261406o447b95b2i18c937a6c738f8db@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 9:06 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Sat, Apr 26, 2008 at 3:14 PM, Ingo Molnar <mingo@elte.hu> wrote:
>  >  > Can you add this please, see if it triggers?
>  >
>  >  there's fixes pending in this area. The main fix would be the one below.
>  >
>  >         Ingo
>  >
>  >  ---------------->
>  >  Subject: idle (arch, acpi and apm) and lockdep
>
>  FWIW, I was seeing the same lockdep trace with eventual hangs, and
>  this patch (applied with some fuzz) fixed the problem.
>
>  --
>  Bob Copeland %% www.bobcopeland.com
>

Just out of curiosity I put the kernel back to it's original state,
were the freezing occurs, then booted with nohz=off, then added
WARN_ON(!irqs_disabled()); to sched.c only to the kernel, no other
patches, upon rebooting
I received different results: The screen from what I could tell was
spitting out the spinlock messages, but instead of printing that out,
and going on to the next task it just keep't printing, from what I
could tell something with ehci, uhci, agpgart, ieee1394 etc... too
fast to really make anything out, the numbers on the left side keept
moving upward, the fans started hauling ass, I waitied a few minuetes
hopeing this would stop
so I can grab dmesg, but it would'nt. is there a way to use the boot
param to write date to a file? so I could capture this event.
regards

-- 
Justin P. Mattock
