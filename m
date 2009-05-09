Return-Path: <linux-kernel-owner+w=401wt.eu-S1756140AbZEID5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140AbZEID5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 23:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZEID5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 23:57:12 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:22223 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbZEID5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 23:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Kgr02QsdCplByJc0ofzvEXh8UimG+3DOF6FzNS/M8rsFbYjPqLrVvkVAZgwF3GUG1C
         Q1pidb3+tsIaCuBulSUgO1nVgvAecdr7RgwWSM8zVp9GdRp6EqEaDx4KAZ0IyaB3htkX
         ye7jmqLvr0VB2c+vfFXrcNGYxS7Hdj29ZIErI=
MIME-Version: 1.0
In-Reply-To: <200905082036.26204.dmitry.torokhov@gmail.com>
References: <4A012C64.1020101@samsung.com> <20090508031859.GE30616@dtor-d630.eng.vmware.com> 
	<4d34a0a70905081858y56dacf34of004301f93daf3e3@mail.gmail.com> 
	<200905082036.26204.dmitry.torokhov@gmail.com>
From: Kim Kyuwon <chammoru@gmail.com>
Date: Sat, 9 May 2009 12:56:51 +0900
Message-ID: <4d34a0a70905082056g599aef37i46b0db46854bab51@mail.gmail.com>
Subject: Re: Input: add MAX7359 key switch controller driver
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Kim Kyuwon <q1.kim@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 9, 2009 at 12:36 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Kim,
>
> On Friday 08 May 2009 18:58:45 Kim Kyuwon wrote:
>> By the way, can I ask the same question which I ask to Trilok.
>> Even though I guard suspend/resume with #ifdef CONFIG_PM in the new
>> patch, Could I know the good reason for this protection? Because
>> '/Documentation/SubmittingPatches' says "ifdefs are ugly"
>
> If kernel is compiled without CONFIG_PM then these functions would
> be just dead weight. Generally speaking, #ifdefs are considered ugly
> if they are in the middle of function code, affecting logic. But to
> to compile out unneeded functionality they are OK. That's why you
> often see in the kernel
>
> #ifdef CONFIG_BAZ
> void do_baz()
> {
>        .. real code ..
> }
> #else
> void do_baz()
> {
> }
> #endif
>
> and then...
>
> int foo()
> {
>        bar1();
>        bar2();
>        do_baz();
>        bar3();
> }
>
>
> As you can see, foo()'s logic stays the same, there are no #ifdefs
> cluttering it, but baz code either executed or not.
>
> Hope this helps.

Thank you for your kind explanation. It is very helpful to me and my colleagues.

Kyuwon
