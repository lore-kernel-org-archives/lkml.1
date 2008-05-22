Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbYEVA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbYEVA1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 20:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbYEVA1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 20:27:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57120 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762143AbYEVA1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 20:27:23 -0400
Date: Wed, 21 May 2008 17:26:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       linux-fbdev-devel@lists.sourceforge.net, adaplas@gmail.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       mingo@redhat.com, plc@novell.com
Subject: Re: [PATCH 1/5] xen: Enable console tty by default in domU if it's
 not a dummy
Message-Id: <20080521172613.18eb24c4.akpm@linux-foundation.org>
In-Reply-To: <878wy4m4px.fsf@pike.pond.sub.org>
References: <87d4ngm4s4.fsf@pike.pond.sub.org>
	<878wy4m4px.fsf@pike.pond.sub.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 10:38:50 +0200
Markus Armbruster <armbru@redhat.com> wrote:

> Without console= arguments on the kernel command line, the first
> console to register becomes enabled and the preferred console (the one
> behind /dev/console).  This is normally tty (assuming
> CONFIG_VT_CONSOLE is enabled, which it commonly is).
> 
> This is okay as long tty is a useful console.  But unless we have the
> PV framebuffer, and it is enabled for this domain, tty0 in domU is
> merely a dummy.  In that case, we want the preferred console to be the
> Xen console hvc0, and we want it without having to fiddle with the
> kernel command line.  Commit b8c2d3dfbc117dff26058fbac316b8acfc2cb5f7
> did that for us.
> 
> Since we now have the PV framebuffer, we want to enable and prefer tty
> again, but only when PVFB is enabled.  But even then we still want to
> enable the Xen console as well.
> 
> Problem: when tty registers, we can't yet know whether the PVFB is
> enabled.  By the time we can know (xenstore is up), the console setup
> game is over.
> 
> Solution: enable console tty by default, but keep hvc as the preferred
> console.  Change the preferred console to tty when PVFB probes
> successfully, unless we've been given console kernel parameters.

What a stunningly good changelog - I'd buy the tee-shirt.

Ack on the non-xen bits.
