Return-Path: <linux-kernel-owner+w=401wt.eu-S1752089AbZBCCj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbZBCCj0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 21:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbZBCCjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 21:39:17 -0500
Received: from wa-out-1112.google.com ([209.85.146.178]:42509 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZBCCjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 21:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ik3lO+F1qlczUb5XyjCurNm3fLAwzdVgWbjluexD1Zd/o2nVkb19E1kvOXLNSszZff
         tdPbKdwtdKxlJ5OyRN/HInnr9j4hUeCd5ZQIYj/8ceirSTiLiE5N8JSoYf9G+/7Orns/
         63lqEkMNr/LLIEVTmuPNdY+flaVsf0/XWv7PA=
MIME-Version: 1.0
In-Reply-To: <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com>
References: <3f43f78b0902011432y354c1b35m8f645640433f7b49@mail.gmail.com>
	 <20090201174159.4a52e15c.akpm@linux-foundation.org>
	 <20090202064509.GA20237@redhat.com>
	 <3f43f78b0902012310p46186417m66873f410b948fd3@mail.gmail.com>
	 <20090202165606.GA13346@redhat.com> <498754EF.8090604@redhat.com>
	 <3f43f78b0902021239s21566f76hf7f59850b2dbf45a@mail.gmail.com>
Date: Mon, 2 Feb 2009 18:39:15 -0800
Message-ID: <3f43f78b0902021839j1eb1eb04u49be47277c99900d@mail.gmail.com>
Subject: Re: main thread pthread_exit/sys_exit bug!
From: Kaz Kylheku <kkylheku@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 2, 2009 at 12:39 PM, Kaz Kylheku <kkylheku@gmail.com> wrote:
> On Mon, Feb 2, 2009 at 12:17 PM, Ulrich Drepper <drepper@redhat.com> wrote:
>> The userlevel context of the
>> thread is not usable anymore.  It will have run all kinds of
>> destructors.  The current behavior is AFAIK that the main thread won't
>> react to any signal anymore.  That is absolutely required.
>
> Hey Ulrich,
>
> Thanks for articulating that requirement. I think it can be met by
> extending the patch a little bit.

I've now done that.

The exiting thread leader, if there are still other
threads alive, gets its own private signal handler array in which
every action is set to SIG_IGN, using the ignore_signals
function.

I experimented with blocking signals, but that approach
breaks the test case of being able to attach GDB to the
exiting thread.

As part of the patch, I found it convenient to extend the
incomplete sys_unshare functionality w.r.t. signal handlers,
rather than reinvent the wheel.

Cheers ...

http://sourceware.org/bugzilla/attachment.cgi?id=3702
http://sourceware.org/bugzilla/attachment.cgi?id=3705
