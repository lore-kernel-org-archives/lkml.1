Return-Path: <linux-kernel-owner+w=401wt.eu-S1754095AbZBNVWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbZBNVWr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 16:22:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZBNVWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 16:22:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44105 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZBNVWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 16:22:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] x86_64: fix s3 fail path
Date: Sat, 14 Feb 2009 22:22:03 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: lenb@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@suse.cz>
References: <1234190120-6268-1-git-send-email-jirislaby@gmail.com> <200902142121.46987.rjw@sisk.pl> <499728AC.90609@gmail.com>
In-Reply-To: <499728AC.90609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902142222.03895.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 14 February 2009, Jiri Slaby wrote:
> Rafael J. Wysocki napsal(a):
> > On Monday 09 February 2009, Jiri Slaby wrote:
> >> As acpi_enter_sleep_state can fail, take this into account in
> >> do_suspend_lowlevel and don't return to the do_suspend_lowlevel's
> >> caller. This would break (currently) fpu status and preempt count.
> >>
> >> Technically, this means use `call' instead of `jmp' and `jmp' to
> >> the `resume_point' after the `call' (i.e. if
> >> acpi_enter_sleep_state returns=fails). `resume_point' will handle
> >> the restore of fpu and preempt count gracefully.
> >>
> >> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> >> Cc: Len Brown <lenb@kernel.org>
> >> Cc: Pavel Machek <pavel@suse.cz>
> >> Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > What kernel is this patch against?  It doesn't apply to the mainline.
> 
> It is applicable even after
> [PATCH v2 1/1] x86_64: acpi/wakeup_64 cleanup
> from
> http://lkml.org/lkml/2009/2/7/101
> which is not present anywhere so far.

Thanks, I'm going to push both patches through Len, if Ingo doesn't mind.

Rafael
