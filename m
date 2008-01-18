Return-Path: <linux-kernel-owner+w=401wt.eu-S1764330AbYARUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764330AbYARUl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 15:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760280AbYARUlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 15:41:21 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:55542 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759396AbYARUlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 15:41:19 -0500
Date: Fri, 18 Jan 2008 21:41:25 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Glauber de Oliveira Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       tglx@linutronix.de, mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, rostedt@goodmis.org, hpa@zytor.com,
       zach@vmware.com, roland@redhat.com, mtosatti@redhat.com
Subject: Re: [PATCH 9/10] provide __parainstructions section
Message-ID: <20080118204125.GA20904@uranus.ravnborg.org>
References: <12006768251548-git-send-email-gcosta@redhat.com> <12006768362108-git-send-email-gcosta@redhat.com> <1200676842822-git-send-email-gcosta@redhat.com> <12006768473571-git-send-email-gcosta@redhat.com> <12006768521391-git-send-email-gcosta@redhat.com> <1200676857691-git-send-email-gcosta@redhat.com> <12006768631010-git-send-email-gcosta@redhat.com> <12006768683247-git-send-email-gcosta@redhat.com> <12006768732175-git-send-email-gcosta@redhat.com> <12006768793416-git-send-email-gcosta@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12006768793416-git-send-email-gcosta@redhat.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 03:20:24PM -0200, Glauber de Oliveira Costa wrote:
> This patch adds the __parainstructions section to vmlinux.lds.S.
> It's needed for the patching system.
> 
> Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
> ---
>  arch/x86/kernel/vmlinux_64.lds.S |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
> index 5ae8aa8..5e0300f 100644
> --- a/arch/x86/kernel/vmlinux_64.lds.S
> +++ b/arch/x86/kernel/vmlinux_64.lds.S
> @@ -175,6 +175,14 @@ SECTIONS
>    }
>    __con_initcall_end = .;
>    SECURITY_INIT
> +
> +  . = ALIGN(8);
> +  .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
> +  __parainstructions = .;
> +       *(.parainstructions)
> +  __parainstructions_end = .;
> +  }
> +

Are we going to see this for other archs than just x86?
If so then please add this to include/asm-generic/vmlinux.lds.h

The altinstructions right below is antoehr candidate..

	Sam
