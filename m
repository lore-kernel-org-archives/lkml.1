Return-Path: <linux-kernel-owner+w=401wt.eu-S1754966AbZGURGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbZGURGn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 13:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZGURGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 13:06:42 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:56581 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbZGURGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 13:06:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bRbMd+YABiagw7TE1SvfqHcNt6dCdcv8eJYsAPydOmwpgG+pDweNDCVg3yQ2s1JfL4
         HUBICoYaAqdmAus2B/Ky1yNxEeBMPNVk6YKNfIz/vpICYqEUFKe1HHlSbj3xgno62mBM
         MYsQyXD2KvH8BkI8BViCNwPC8+WWPjQt2W7ag=
MIME-Version: 1.0
In-Reply-To: <20090721165248.GA27549@tango.0pointer.de>
References: <20090721165248.GA27549@tango.0pointer.de>
Date: Tue, 21 Jul 2009 19:06:41 +0200
Message-ID: <1158166a0907211006u5e2933f8y40dd2c56055bfc93@mail.gmail.com>
Subject: Re: Can access to /proc/$PID/exe be relaxed?
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Lennart Poettering <mzxreary@0pointer.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 6:52 PM, Lennart Poettering<mzxreary@0pointer.de> wrote:
> Hi!
>
> Unless I am mistaken a process currently needs CAP_SYS_PTRACE to read
> /proc/$PID/exe for abritrary processes.

You mean "readlink'?

> Does that make sense? Could
> that be relaxed? Is there any reason to limit access to that link at
> all? To me the data from /proc/$PID/cmdline seems to be far more
> worthy to be protected than /proc/$PID/exe, or am I missing something?
>
> Tbh, looking at the code I don't really get where CAP_SYS_PTRACE seems
> to be required, but experimenting from userspace this seems to be the
> case.

Another annoying thing is that sometimes processes cannot open
their own /proc/self/fd/N. Example:

# setuidgid 200:200 cat /proc/self/fd/0
cat: /proc/self/fd/0: Permission denied

In real life this happened when I wanted to redirect apache's
log to stderr. The config directive only allowed redirecting
to a file, so I specified /proc/self/fd/2. It does not work
if apache drops root after startup.

--
vda
