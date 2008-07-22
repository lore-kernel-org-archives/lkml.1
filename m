Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbYGVUS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbYGVUS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 16:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbYGVUSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 16:18:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:37276 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbYGVUSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 16:18:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nYpWBSySS0WBN8Fc76ZrX7pf2sziXhb8yyUZBj1yAXLbn1dySMusBEgJN5xJZa3/4O
         NY1/Zkj9DFwpT1dQryXMAjFeXOP2sQ9gVPsuLmk22+T1JYXqnchHHNWiNfKAbkq6Wvqa
         lNccJjT2aR7GShgQprOSXrJ387d6E1ZogpR6k=
Message-ID: <5a4c581d0807221318l12989994u121f07dad47f5a0a@mail.gmail.com>
Date: Tue, 22 Jul 2008 22:18:45 +0200
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Alessandro Guido" <ag@alessandroguido.name>
Subject: Re: [BUG] kernel BUG at net/core/dev.c:1328!
Cc: "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <d4b984a30807210914nd4d0db5yb7b93ca5143ff0d5@mail.gmail.com>
	 <20080721.092027.14394005.davem@davemloft.net>
	 <d4b984a30807220254t1aaf6ac4q874329966511b0c5@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2008 at 11:54 AM, Alessandro Guido
<ag@alessandroguido.name> wrote:
> Got a WARNING this morning (2.6.26-05752-g93ded9b) and I think it's related.
>
>
> WARNING: at net/core/dev.c:1330 __netif_schedule+0x53/0x60()
> Modules linked in:
> Pid: 5, comm: events/0 Not tainted 2.6.26-05752-g93ded9b #1
>  [<c011bc64>] warn_on_slowpath+0x54/0xa0
>  [<c0135483>] ? getnstimeofday+0x53/0x100
>  [<c0132d1c>] ? ktime_get_ts+0x4c/0x50
>  [<c012ba67>] ? insert_work+0x57/0x70
>  [<c012c129>] ? queue_work+0x39/0x60
>  [<c012c1e5>] ? queue_delayed_work+0x25/0x30
>  [<c012c201>] ? schedule_delayed_work+0x11/0x20
>  [<c030398a>] ? linkwatch_schedule_work+0x3a/0xb0
>  [<c02f78d3>] __netif_schedule+0x53/0x60
>  [<c0262a80>] ipw_bg_link_up+0x160/0x1f0
>  [<c035ae4e>] ? schedule+0x1de/0x3f0
>  [<c012bdef>] run_workqueue+0x6f/0x160
>  [<c0262920>] ? ipw_bg_link_up+0x0/0x1f0
>  [<c012c08f>] worker_thread+0x7f/0xe0
>  [<c012f5d0>] ? autoremove_wake_function+0x0/0x50
>  [<c012c010>] ? worker_thread+0x0/0xe0
>  [<c012f15a>] kthread+0x3a/0x70
>  [<c012f120>] ? kthread+0x0/0x70
>  [<c0103d77>] kernel_thread_helper+0x7/0x10
>  =======================

I also hit a very similar one on my Dell D610 with onboard
 ipw2200 wireless (already kerneloops'd, BTW):

WARNING: at net/core/dev.c:1330 __netif_schedule+0x2a/0x63()
Modules linked in: fuse sunrpc iptable_filter ip_tables
ip6table_filter ip6_tables x_tables ipv6 cpufreq_ondemand ppdev pcmcia
dcdbas parport_pc parport snd_intel8x0 snd_intel8x0m snd_ac97_codec
snd_seq_dummy ac97_bus snd_seq_oss snd_seq_midi_event snd_seq
snd_seq_device snd_pcm_oss pcspkr snd_mixer_oss snd_pcm snd_timer snd
ipw2200 soundcore snd_page_alloc i2c_i801 ieee80211 ieee80211_crypt
yenta_socket rsrc_nonstatic pcmcia_core video output pata_acpi
ata_piix uhci_hcd ehci_hcd [last unloaded: microcode]
Pid: 5, comm: events/0 Not tainted 2.6.26-git9 #5
 [<c0118cda>] warn_on_slowpath+0x46/0x80
 [<c0113a91>] ? __enqueue_entity+0xe3/0xeb
 [<c0113754>] ? __wake_up+0x31/0x3b
 [<c0125ebb>] ? __queue_work+0x2d/0x32
 [<c0125f05>] ? queue_work+0x2a/0x34
 [<c01261ff>] ? queue_delayed_work+0x11/0x23
 [<c0126227>] ? schedule_delayed_work+0x16/0x1b
 [<c02ce1d5>] ? linkwatch_schedule_work+0x58/0x99
 [<c02ce278>] ? linkwatch_fire_event+0x62/0x66
 [<c02c567f>] __netif_schedule+0x2a/0x63
 [<f8990009>] ipw_bg_link_up+0xae/0x173 [ipw2200]
 [<c0125a0f>] run_workqueue+0x7d/0xf6
 [<f898ff5b>] ? ipw_bg_link_up+0x0/0x173 [ipw2200]
 [<c0125cec>] worker_thread+0xb7/0xc3
 [<c0128862>] ? autoremove_wake_function+0x0/0x38
 [<c0125c35>] ? worker_thread+0x0/0xc3
 [<c01285d3>] kthread+0x3e/0x63
 [<c0128595>] ? kthread+0x0/0x63
 [<c0103003>] kernel_thread_helper+0x7/0x10

But it works - to the point that I'm connected to my wireless
 router without apparent issues.

--alessandro

 "Give me love / Or give me hate
 Give me anything that's not just ok"

 (Sophia, 'Weightless')
