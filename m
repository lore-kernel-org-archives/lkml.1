Return-Path: <linux-kernel-owner+w=401wt.eu-S1763493AbZEIDgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763493AbZEIDgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753803AbZEIDgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:36:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:37213 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965AbZEIDgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=qknsMQA5soDLLZ9NsZX3kZ65DmoZ+ypDelY8qYl8/cLwKprWLyiSjbaiZhU+Y+wcye
         devFhGbvRdYIC9RV/5eqEGssF4SWcSOmN6ySwOYEsM7BK1oS7OVQuiNLmLgUYkSk6PGw
         5vnDfofaS56aJMDIMH2Qyzc3GEXrfHVt4nsYo=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Kim Kyuwon <chammoru@gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
Date: Fri, 8 May 2009 20:36:25 -0700
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc4; KDE/4.2.2; x86_64; ; )
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
References: <4A012C64.1020101@samsung.com> <20090508031859.GE30616@dtor-d630.eng.vmware.com> <4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com>
In-Reply-To: <4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905082036.26204.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kim,

On Friday 08 May 2009 18:58:45 Kim Kyuwon wrote:
> By the way, can I ask the same question which I ask to Trilok.
> Even though I guard suspend/resume with #ifdef CONFIG_PM in the new
> patch, Could I know the good reason for this protection? Because
> '/Documentation/SubmittingPatches' says "ifdefs are ugly"

If kernel is compiled without CONFIG_PM then these functions would
be just dead weight. Generally speaking, #ifdefs are considered ugly
if they are in the middle of function code, affecting logic. But to
to compile out unneeded functionality they are OK. That's why you
often see in the kernel

#ifdef CONFIG_BAZ
void do_baz()
{
	.. real code ..
}
#else
void do_baz()
{
}
#endif

and then...

int foo()
{
	bar1();
	bar2();
	do_baz();
	bar3();
}


As you can see, foo()'s logic stays the same, there are no #ifdefs
cluttering it, but baz code either executed or not.

Hope this helps.

-- 
Dmitry
