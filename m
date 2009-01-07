Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZAGVCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZAGVCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 16:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757838AbZAGVCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 16:02:35 -0500
Received: from mail-gx0-f13.google.com ([209.85.217.13]:54402 "EHLO
	mail-gx0-f13.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbZAGVCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 16:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=xcY4jy81BlfiRnEzcMexPZeHEF0ROqGE1MyOAgBFqei0VbK3PrC7m7OoFivqjiywnZ
         NlL1Psq7MKWF04SKOMKiaxxs+so5GdhTu6My4/wLn2ycB6BOHDO9K5pb2gV9idvOb/pw
         xBIwbTe+7d5MbWhmC6o6DI9aFzb1vh+pF+G3E=
Message-ID: <a36005b50901071302q70160bady41abc5ed2b105474@mail.gmail.com>
Date: Wed, 7 Jan 2009 13:02:32 -0800
From: "Ulrich Drepper" <drepper@gmail.com>
To: "Roland McGrath" <roland@redhat.com>
Subject: Re: [RESEND][RFC PATCH v2] waitfd
Cc: "Ingo Molnar" <mingo@elte.hu>, "Casey Dahlin" <cdahlin@redhat.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Oleg Nesterov" <oleg@redhat.com>,
       "Davide Libenzi" <davidel@xmailserver.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>
In-Reply-To: <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>
	 <20090107205322.5F8C7FC3E0@magilla.sf.frob.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2009 at 12:53 PM, Roland McGrath <roland@redhat.com> wrote:
> Do we really need another one for this?  How about using signalfd plus
> setting the child's exit_signal to a queuing (SIGRTMIN+n) signal instead of
> SIGCHLD?  It's slightly more magical for the userland process to know to do
> that (fork -> clone SIGRTMIN).  But compared to adding a syscall we don't
> really have to add, maybe better.

Since waitfd shouldn't consume the child termination notification
waitfd should be more widely usable than the wait*() interfaces.
I.e., it's not necessary to restrict the use to parents.  Any process
with the same UID should be allowed to call waitfd.  This would allow
some new user cases.
