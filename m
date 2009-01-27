Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbZA0XmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbZA0XmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751272AbZA0Xl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:41:59 -0500
Received: from mail-qy0-f11.google.com ([209.85.221.11]:41158 "EHLO
	mail-qy0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121AbZA0Xl7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:41:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cyrtNO+jiQJ9cX6r5gcABkzcoU/AdKuFW83kpKxIxiKNMO4Bqfcm6KhwhP2QSa3n/v
         AEnHYYpy83vwC0J+VWE1abhyQ2uByy6zPHOAatV8a/wccOSZ/QJiLd29UXf4+UtMSq6N
         XFOMBC5bcRGeIZ4NaaGFDFG1TlfA2dobpn3Ds=
MIME-Version: 1.0
In-Reply-To: <m1eiyobei1.fsf@fess.ebiederm.org>
References: <1457226967.823651233090019084.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
	 <m1eiyobei1.fsf@fess.ebiederm.org>
Date: Tue, 27 Jan 2009 18:41:57 -0500
Message-ID: <170fa0d20901271541w3c5175aar60908df7c641f176@mail.gmail.com>
Subject: Re: BISECTED: Re: source line numbers with x86_64 modules?
From: Mike Snitzer <snitzer@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Dave Anderson <anderson@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Bernhard Walle <bwalle@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       crash-utility@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 4:55 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Dave Anderson <anderson@redhat.com> writes:
>
>> Actually it's not a problem with the vmlinux file, but rather with kernel
>> module object files.  The crash utility has an embedded gdb module which
>> is invoked as "gdb vmlinux", and to get line numbers, the crash utility
>> simply uses the relevant built-in gdb function to get them.  And line
>> numbers work fine with the base kernel code from the vmlinux file.
>>
>> The debuginfo data of kernel modules can be subsequently added to the
>> crash session by doing a gdb "add-symbol-file" command for any or all
>> kernel modules.  But getting correct line number information for kernel
>> modules has been a crap-shoot in the past, depending upon architecture
>> and/or kernel version.  For example, they don't work with 2.6.9-based
>> RHEL4 x86_64 kernel modules, but work fine with 2.6.18-based RHEL5 x86_64
>> kernels.
>>
>> Looking at Mike's suspect kernel patch list, I don't see anything that
>> would have any relationship to the issue.  Perhaps there was a build tool
>> change during the same timeframe?
>
> It look like Mike just built a series of kernels and had a problem,
> which should preclude a tool change.

That is correct, I just built/booted/tested a series of kernels one
after the other as part of the standard git bisect procedure.  No
tools were changed.

> That said.  Does this feature of crash work in 2.6.29?  If not is
> there enough interest to track this down, and fix it if it is a kernel
> bug?
>
> If we are going to be using these tools we need them working on the
> latest and greatest kernels, not some weird enterprise branch, for
> fuddy duddies.

This feature of crash does not work with 2.6.29, nor does it work with
any kernel I've tried >= 2.6.21.  Andi Kleen shared with me that he
sees the same problem with a recent crash and 2.6.28.

AFAIK I found the regression point relative to linux (commit:
7460ed28).  The verdict is clearly still out on where the actual bug
lives (linux vs crash).

Mike
