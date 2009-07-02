Return-Path: <linux-kernel-owner+w=401wt.eu-S1752929AbZGBQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbZGBQrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752378AbZGBQqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 12:46:53 -0400
Received: from smtp-out.google.com ([216.239.45.13]:5598 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752297AbZGBQqw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:46:52 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=PNBylN3QPr20m6bIl6zo0pWCIIZvXa3DyNazWlFOKH7XN9x1LOW3fxDyEW1VYAdDy
	YhVOzNleJYi4Bi4Iy/Y2Q==
MIME-Version: 1.0
In-Reply-To: <20090702163731.GA14267@us.ibm.com>
References: <4A4C0C60.4050106@cn.fujitsu.com>
	 <6599ad830907020926t6305bec9t44a50cc165f6fc28@mail.gmail.com>
	 <20090702163731.GA14267@us.ibm.com>
Date: Thu, 2 Jul 2009 09:46:51 -0700
Message-ID: <6599ad830907020946r42735c9es642bddf37af755ed@mail.gmail.com>
Subject: Re: [PATCH][BUGFIX] cgroups: fix pid namespace bug
From: Paul Menage <menage@google.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 9:37 AM, Serge E. Hallyn<serue@us.ibm.com> wrote:
>
>        1. the only way it won't outlive the open file is if the
>                task opens the file, hands the open fd over a
>                unix socket, then exits as the last task of its
>                pidns

Right.

>        2. We don't dereference the pid_ns, so there is no actual
>                safety issue.  So it would become a problem only
>                if a new pidns gets created at that same address

Which is fairly likely given that pid_namespace is allocated from a
specific cache.

Paul
