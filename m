Return-Path: <linux-kernel-owner+w=401wt.eu-S935519AbXHHPcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519AbXHHPcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763463AbXHHPcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:32:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36705 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763428AbXHHPcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:32:22 -0400
Message-ID: <46B9E1F9.6000103@redhat.com>
Date: Wed, 08 Aug 2007 11:32:09 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: lkml@contacts.eelis.net
CC: linux-kernel@vger.kernel.org
Subject: Re: Inconsistent execve SIGTRAP-ing after ptraced child's      PTRACE_TRACEME.
References: <50598.213.84.80.149.1186526621.squirrel@webmail.nxs.nl>
In-Reply-To: <50598.213.84.80.149.1186526621.squirrel@webmail.nxs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2007 06:43 PM, Eelis van der Weegen wrote:
> How can a parent process intercepting a ptraced child's system calls using
> PTRACE_SYSCALL know which SIGTRAP's are system call entries and which are system
> call exits?
> 
> Since there does not seem to be a way for the parent to get this information
> from the system, ptrace examples floating around on the web generally use a
> boolean in_syscall flag that they toggle at each SIGTRAP. This mechanism seems
> perfectly adequate, but for it to work correctly the flag must obviously be
> appropriately initialized, and that is where things get vague.
> 
> Let's assume that the child's ptrace-ing begins after it first does
> PTRACE_TRACEME and then calls execve. According to the ptrace man page, after
> doing PTRACE_TRACEME "all subsequent calls to exec() by this process will cause
> a SIGTRAP to be sent to it, giving the parent a chance to gain control before
> the new program begins execution". The problem is that this does not specify
> whether the parent will see SIGTRAP's for both entry to and exit from execve, or
> only for exit from it. To my great surprise, I observed both behaviors on actual
> machines (in particular, I observed the former on an x86_64 dual core machine).
> 
> This inconsistency foils the in_syscall flag approach, as there is no way to
> know whether the parent should initialize that flag to true or false (since
> apparently both can occur). Hence, my question is: is this behavior intentional?
> Should there not be a guarantee that /either/ only the execve exit, /or/ both
> entry and exit, are SIGTRAPed?
> 

Did you try PTRACE_SETOPTIONS and set PTRACE_O_TRACEEXEC?
