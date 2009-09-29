Return-Path: <linux-kernel-owner+w=401wt.eu-S1754071AbZI2ULF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbZI2ULF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 16:11:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbZI2ULE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 16:11:04 -0400
Received: from mail.tmr.com ([64.65.253.246]:47872 "EHLO partygirl.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914AbZI2ULD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 16:11:03 -0400
Message-ID: <4AC269D4.4040605@tmr.com>
Date: Tue, 29 Sep 2009 16:11:00 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090507 Fedora/1.1.16-1.fc9 SeaMonkey/1.1.16
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Taro Okumichi <tarookumichi@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: visibility of linux source
References: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
In-Reply-To: <25a94d2a0909281502u2bb383aemdb44f4af8ffdc9e7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Taro Okumichi wrote:
> I have written a gcc-tracer and html-formatter that shows
> Linux's init/main.c formatted as dynamic-html including:
>  o expand macros by clicking on them
>  o expand include directives
>  o traverse c-structs
> Address:
> http://cfw.sourceforge.net/htmltag/init/main.c.pinfo.html
> I have only processed init/main.c (50mb mysql content)
> As far as I understand (maybe I am wrong) this kind of
> visibility is not achieved till now.
> Note:
> I tested firefox (3.5) and konqueror. The first page takes ~
> 10 Seconds to load, therefore be patient until the right
> side init/main.c content is shown (ajax fetch from a mysql db).
> 
Just for the record, I tried seamonkey 1.1.17 and it works well there, as well. 
I'll try the daily test version, but unless I find a problem assume it works, 
using much code from Firefox{recent}.

I'd like to try with Chrome, I suspect it will be faster there.

> o Complete Preprocessor Trace:
>    All Macro expansions where traced and can be clicked
>    open to see how they expand and where the macro was
>    defined.
>   - to open a macro expansion: click the macro marked
>     with a white box,
>     + after the macro has been expanded you can:
>     + click the macro name to get the macro definition location
>     + a "<" link appears at the end of the macro expansion,
>        click it to close the macro expansion again.
>   - #ifdef etc. preprocessor directives
>     can also be expanded. Blocks that are inactive are
>     marked grey.
>   - #include directives can be clicked to expand to the
>     included file
> 
> o Variable/function declares are Trace:
>    Full struct type layout is traced and when a struct
>    types is used you can click on the type declarator,
> 
> To get going:
> 1. Browse to the end of init/main.c page:
> 2. click on
>     "param_check_bool" it will expand to:
>      param_check_bool __param_check ( initcall_debug , & (
> initcall_debug ) , int )[<]
>      Click on param_check_bool again, it will sow the definition pos of
>      the macro, click on "<" and it will close the expansion,
>      You can recursively ascend into for instance expanding __param_check etc...
> 
> 
> I thought to share this link to inspire some real gcc experts
> or kernel hackers to implement this kind of feature in the production
> gcc, I was using gcc-4.2.1 to output a cpp and c-parse trace
> however the code is that kind of messy and would be of no
> use, easier to implement newly, I guess that it should be obvious
> what to do for for the right person. After getting the trace I use
> a simple perl script (also messy code that I'm kind of ashamed to
> publish) to format html.
> 
> Implementation note:
> 
> Using a ajax request to retrieve the html, the Mysql db
> content is ~ 50 mb for the whole of main.c. No optimization
> is done, so this includes lots of redundant entries.
> 
> The left index frame should not be used, the javascript code
> is kind of buggy, so only use the right frame where the code
> is shown.
> 
> Also: There is a bug in when closing a "include" directive section:
> (At least in firefox) A new windows will pop up (I didnt find out
> why this is the case). Click the window to the back and continue
> (not closing it otherwise the next #include directive opens it again...
> 
> Have fun
> -- Tkokum


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
