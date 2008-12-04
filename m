Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbYLDUSs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbYLDUSs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 15:18:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbYLDUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 15:18:38 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:64577 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbYLDUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 15:18:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=v97jUfMwxknbkJo5hUmf+GMNgvaBXTPzS5RmXOs3c0btYT+P1S47VQxk8cZ18wQY5F
         9sauUhqsrnRrGN6TKIZMcw32WQeWrp9E5n/ICDjG86tnBGD1RO7Bi2lu13cAH/ooiScn
         wkOz6juJSJtMF32h0Ja8WGucjs4BOfUiBA45M=
Message-ID: <3e8340490812041218l7b4633fev5126f25a5d33076c@mail.gmail.com>
Date: Thu, 4 Dec 2008 15:18:35 -0500
From: "Bryan Donlan" <bdonlan@gmail.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Could you write some CLONE_NEWUSER?
Cc: mtk.manpages@gmail.com, ebiederm@xmission.com,
       lkml <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
       clg@fr.ibm.com, herbert@13thfloor.at, dev@sw.ru,
       "Subrata Modak" <subrata@linux.vnet.ibm.com>,
       "David Howells" <dhowells@redhat.com>
In-Reply-To: <20081204190430.GA16026@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <cfd18e0f0812040720y5cabd2aarbf3912644dea42c4@mail.gmail.com>
	 <20081204190430.GA16026@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 4, 2008 at 2:04 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Michael Kerrisk (mtk.manpages@googlemail.com):
>> Hi Serge,
>>
>> Thanks for CCing me on recent CLONE_NEWUSER patches.
>>
>> Would you be will to write some documentation for this flag?  (It's
>> the only remaining undocumented flag in clone(2).)  Plain text would
>> be fine -- I'll integrate it into the man page with suitable macros.
>
> Well here is a start.  David, writing this actually reminded me that
> the per-user keys still aren't per-namespace.  Did you say you were
> looking at that, or should I send a patch (starting at
> security/keys/key.c:key_user_lookup())?
>
> Eric, if you get a second, could you please review?
>
> thanks,
> -serge
>
>
> CLONE_NEWUSER
>        Start the child in a new user namespace.
>
>        User namespaces are very incomplete.  When complete, they
>        will implement hierarchical userid namespaces designed to
>        be safely used without privilege.  User namespaces are
>        unnamed, but for the sake of this explanation we will give
>        them a single-letter ID.  Let us refer to userid 500 in user
>        namespace B  as (B, 500).  Assume a process owned by (B, 500)
>        passes CLONE_NEWUSER to clone(2).  A new user namespace, C,
>        will be created.  The new task will be owned by user
>        (C, 0).  No userid in user namespace C will be able to
>        gain more access than (B, 500) could obtain.  User (C, 500)
>        will be protected from (C, 501) as usual.  Files created
>        by (C, 501) are owned by both (C, 501) and (B, 500), so
>        (B, 500) owns all files created in user namespace C.  Likewise
>        (B, 500) can kill and ptrace any processes owned by (C, 501).

This is something more of a general question than one about this
manpage, but how will files owned by user namespaces be represented on
the underlying filesystem? Since (C, 501) will be meaningless after a
reboot at the latest, it makes little sense to persist them...
