Return-Path: <linux-kernel-owner+w=401wt.eu-S1751679Ab0AZASn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0AZASn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 19:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751393Ab0AZASl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 19:18:41 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751325Ab0AZASk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 19:18:40 -0500
Date: Mon, 25 Jan 2010 16:17:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Travis <travis@sgi.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Ingo Molnar <mingo@elte.hu>,
       Russ Anderson <rja@sgi.com>, Dave Airlie <airlied@redhat.com>,
       Alex Chiang <achiang@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Cyrill Gorcunov <gorcunov@openvz.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robin Holt <holt@sgi.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Adam Jackson <ajax@nwnk.net>,
       Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
       Gaetan Nadon <memsize@videotron.ca>, "H. Peter Anvin" <hpa@zytor.com>,
       Aaron Plattner <aplattner@nvidia.com>, Jack Steiner <steiner@sgi.com>,
       Tiago Vignatti <tiago.vignatti@nokia.com>, Cliff Wickman <cpw@sgi.com>,
       Matthew Wilcox <willy@linux.intel.com>,
       Christian Zander <chzander@nvidia.com>, Yu Zhao <yu.zhao@intel.com>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/4] pci: Update pci_set_vga_state to call arch
 functions
Message-Id: <20100125161702.e070985e.akpm@linux-foundation.org>
In-Reply-To: <4B5E32D0.8040401@sgi.com>
References: <20100118183412.560438000@alcatraz.americas.sgi.com>
	<20100118183418.045021000@alcatraz.americas.sgi.com>
	<20100125155234.a2e397a1.akpm@linux-foundation.org>
	<4B5E32D0.8040401@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Jan 2010 16:09:52 -0800
Mike Travis <travis@sgi.com> wrote:

> > 
> > Still, a neater solution might be
> > 
> > int arch_pci_set_vga_state(...) __weak
> > {
> > 	return 0;
> > }
> > 
> > and then resolve it at linkage time?
> > 
> > 
> 
> Wouldn't the linked in stronger function then need to surround
> the UV register updating with "if (uv_system)"?

If the file which implements arch_pci_set_vga_state() is present in
vmlinux on non-uv systems then yes.

Presumably that file is arch/x86/kernel/apic/x2apic_uv_x.c, although
that might later become a problem if other sub-architectures a) want to
get at this hook and b) can be linked into vmlinux along with
arch/x86/kernel/apic/x2apic_uv_x.o.  But such a kernel wouldn't
actually link, so we'll need to address it at that stage.


If this is a UV-specific hack which other architectures and
sub-architectures are unlikely to need (seems that way?) then I'd be
going for something whcih is simple and minimal.

