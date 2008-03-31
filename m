Return-Path: <linux-kernel-owner+w=401wt.eu-S1757515AbYCaRpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515AbYCaRpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 13:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753093AbYCaRp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 13:45:28 -0400
Received: from rtr.ca ([76.10.145.34]:2586 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751548AbYCaRp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 13:45:28 -0400
Message-ID: <47F12337.3080900@rtr.ca>
Date: Mon, 31 Mar 2008 13:45:27 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Dave Airlie <airlied@gmail.com>
Cc: Tilman Schmidt <tilman@imap.cc>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.25-rc6] possible regression: X server dying
References: <47E82D68.5070305@imap.cc>	 <21d7e9970803241622v10b887a6p869535102b486279@mail.gmail.com>	 <47E83D14.8070800@imap.cc>	 <21d7e9970803241753q433e7545pdd00eae189846a8@mail.gmail.com> <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
In-Reply-To: <21d7e9970803302153s314d48d3o7120a56092eeaede@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Airlie wrote:
> On Tue, Mar 25, 2008 at 10:53 AM, Dave Airlie <airlied@gmail.com> wrote:
>> On Tue, Mar 25, 2008 at 9:45 AM, Tilman Schmidt <tilman@imap.cc> wrote:
>>  > On Tue, 25 Mar 2008 09:22:32 +1000, Dave Airlie wrote:
>>  >  > On Tue, Mar 25, 2008 at 8:38 AM, Tilman Schmidt <tilman@imap.cc> wrote:
>>  >  >> In the five days since I booted a 2.6.25-rc6 kernel on my development
>>  >  >>  machine, it has happened three times already that I came back to the
>>  >  >>  machine to find that the X server had exited, killing all applications
>>  >  >>  that still had a window open. [...]
>>  >
>>  > >
>>  >  > anything in the X.org logfiles?
>>  >
>>  >  Ah, of course. Sorry I forgot. Xorg.0.log.old ends with this:
>>  >
>>  >  | Backtrace:
>>  >  | 0: /usr/bin/X(xf86SigHandler+0x81) [0x80e6d81]
>>  >  | 1: [0xb7fc9400]
>>  >  | 2:
>>  >  /usr/lib/xorg/modules//extensions/libGLcore.so(_swrast_Triangle+0x2d)
>>  >  [0xb51ea5dd]
>>  >  | 3: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb51f1075]
>>  >  | 4: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb5206f2e]
>>  >  | 5: /usr/lib/xorg/modules//extensions/libGLcore.so [0xb52080b8]
>>  >  | 6:
>>  >  /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_run_pipeline+0x153)
>>  >  [0xb520cb83]
>>  >  | 7:
>>  >  /usr/lib/xorg/modules//extensions/libGLcore.so(_tnl_draw_prims+0x3f0)
>>  >  [0xb51f8340]
>>  >  | 8:
>>  >  /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_vtx_flush+0x1fb)
>>  >  [0xb52471eb]
>>  >  | 9:
>>  >  /usr/lib/xorg/modules//extensions/libGLcore.so(vbo_exec_FlushVertices+0x78)
>>  >  [0xb52488e8]
>>  >  | 10: /usr/lib/xorg/modules//extensions/libGLcore.so(_mesa_Flush+0x83)
>>  >  [0xb5112663]
>>  >  | 11: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c6a107]
>>  >  | 12: /usr/lib/xorg/modules//extensions/libglx.so [0xb7c4aa6d]
>>  >  | 13: /usr/bin/X [0x815809e]
>>  >  | 14: /usr/bin/X(Dispatch+0x1af) [0x808f68f]
>>  >  | 15: /usr/bin/X(main+0x47e) [0x807717e]
>>  >  | 16: /lib/libc.so.6(__libc_start_main+0xe0) [0xb7d5dfe0]
>>  >  | 17: /usr/bin/X(FontFileCompleteXLFD+0x1e5) [0x8076501]
>>  >  |
>>  >  | Fatal server error:
>>  >  | Caught signal 11.  Server aborting
>>  >
> 
> any look finding what might have caused this?
> 
> it certainly looks like some heap or address space change affects Mesa.
...

Mmm.. I've had one X-server death so far with 2.6.25-rc7.
Didn't keep the logfile, though.

-ml
