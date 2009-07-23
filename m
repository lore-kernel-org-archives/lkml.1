Return-Path: <linux-kernel-owner+w=401wt.eu-S1752272AbZGWBFJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272AbZGWBFJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:05:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbZGWBFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:05:08 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:42210 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847AbZGWBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BO/1wGGhi80GTSC1mWWniu56T8eEA3OluYDg92gEmVy1cXCd0F0rPHXit7Srnf2Hgg
         j+AYKzceLr2lBMprDkLjUZS6qnf1kZgTnZXeD5x7opPFpsMJYDtR6EJ5Q4H99Blb3MgI
         HZtUTQo9Ll0UTuASnT51zINB+QIExRje4yI1U=
Date: Thu, 23 Jul 2009 09:07:15 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question for C preprocessor wizards
Message-ID: <20090723010715.GA5712@cr0.nay.redhat.com>
References: <4A675F89.50506@nortel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A675F89.50506@nortel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 12:50:49PM -0600, Chris Friesen wrote:
>
>I'm hoping someone can help me out.


This is _not_ a question about kernel. :)

>
>I've got a bunch of code that call a bunch of different wrapper
>routines, with varying numbers of arguments.  Depending on whether a
>compile flag is set, I want to do some stuff before and after calling
>the "real" routine.  I can do this easily enough with a macro.
>
>#if FLAG
>#define func_wrapper(args...) \
>	do { \
>		dostuff(); \
>		func(args); \
>		do_more_stuff(); \
>	} while (0)
>#else
>#define func_wrapper(args...) func(args)
>#endif
>
>
>However, given that there are hundreds of functions, I'd like to
>generate these macros with another macro, sort of like:
>
>#if FLAG
>#define WRAPPER(func) \
>	#define func # _wrapper(args...) \
>	do { \
>		dostuff(); \
>		func(args); \
>		do_more_stuff(); \
>	} while (0)
>#else
>#define WRAPPER(func) \
>	#define func ## _wrapper(args...) func(args)
>#endif
>
>Where I could then do
>
>WRAPPER(func1)
>WRAPPER(func2)
>...
>WRAPPER(func100)
>
>
>However, the preprocessor complains about having that "#" in the macro
>body where it isn't used for stringification.
>
>
>Anyone have any ideas how to accomplish this?  I had considered writing
>an app to programmatically generate an include file as a precursor to
>actually compiling the real app, but I was hoping there was a more
>elegant solution.

Well, you can define func() as a real function instead of a macro,
i.e:

#define WRAPPER(func) \
 void func ## _wrapper(args, ...) \
 {  \
    dostuff(); \
    func(args); \
    do_more_stuff(); \
 }


