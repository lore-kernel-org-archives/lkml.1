Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYIBAsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYIBAsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 20:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbYIBAsq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 20:48:46 -0400
Received: from yx-out-2324.google.com ([74.125.44.28]:54691 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYIBAsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 20:48:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=NReNtz0lD07tVUqnmK36tx22t1WqyjimUc3TkkVKHQT7zc5sbT7S438wwgKOnPeoGj
         gAsWIxOgbvdqrwuG9V7lnglcnpNq0pTGFIaH29cvY02VKAxBJ8bppg2WmvXME2Agd2KH
         b5nObIx/oUutPs452xY21qwrGk9pEZelu6o58=
Message-ID: <a36005b50809011748j75b1984ar844252a57f7e1d50@mail.gmail.com>
Date: Mon, 1 Sep 2008 17:48:44 -0700
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Michael Kerrisk" <mtk.manpages@googlemail.com>
Subject: Re: Rationale for paccept() sigset argument?
Cc: "Ulrich Drepper" <drepper@redhat.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Jakub Jelinek" <jakub@redhat.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <48AC4B44.2010606@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AC4B44.2010606@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2008 at 9:50 AM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
> What is the rationale for the sigset argument of paccept()?

accept, like select/poll, is used often as a function to dealy
operation.  Unlike read, recv, etc, which are handled using O_NONBLOCK
and select/poll.  pselect/ppoll do not really have a sigset parameter
to handle signals in general.  You use it to enable special handling
in case of blocking.  Example: if you want to implement userlevel
context switching, you dedicate a signal to wake up any blocked
thread.  Since accept falls more into the same category than poll,
this means the sigset parameter is justified.  In theory we could add
it to all functions but there is no reason to do this without any
other reason to change the interface.
