Return-Path: <linux-kernel-owner+w=401wt.eu-S1757803AbYEKT1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757803AbYEKT1P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 15:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754360AbYEKT1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 15:27:03 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:13189 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbYEKT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 15:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fpMM1j/nz2wbDMxPcLmwl+3+C4wdRellMZV3/FouSLNr2QzgxtssFDnfvQlojla2MxZ1rkxrkfUzZSGpFvfiaoGqIgjELQm60ZmSVMNni4OOvG62bGzhAXoCR1HON0M8v2a9Yri6aQ13axAAPW47SYEov7FFQ9rhXQ3kPYCmKVY=
Message-ID: <1ba2fa240805111226s6f900015n4144f5411957ef2a@mail.gmail.com>
Date: Sun, 11 May 2008 22:26:59 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Mirco Tischler" <mirco.tischler@physik.uni-wuppertal.de>
Subject: Re: BUG: scheduling while atomic: events/1/10/0x00000002 on linux-next
Cc: lkml <linux-kernel@vger.kernel.org>,
       "Reinette Chatre" <reinette.chatre@intel.com>,
       "Zhu Yi" <yi.zhu@intel.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "Johannes Berg" <johannes@sipsolutions.net>
In-Reply-To: <1210524139.17521.5.camel@mtlp.tischlernetz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210524139.17521.5.camel@mtlp.tischlernetz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2008 at 7:42 PM, Mirco Tischler
<mirco.tischler@physik.uni-wuppertal.de> wrote:
> Hi
>
> I've got this in my dmesg while testing linux-next:
>
>> [4299633.075168] wlan0: deauthenticate(reason=3)
>> [4299633.097015] BUG: scheduling while atomic: events/1/10/0x00000002
>> [4299633.097030] Pid: 10, comm: events/1 Not tainted 2.6.26-rc1-next-20080509 #80
>> [4299633.097036]
>> [4299633.097038] Call Trace:
>> [4299633.097070]  [<ffffffff8023346c>] __schedule_bug+0x70/0x75
>> [4299633.097082]  [<ffffffff8052aa68>] schedule+0xd7/0x8aa
>> [4299633.097094]  [<ffffffff8052cac6>] ? _spin_lock_irqsave+0x1d/0x39
>> [4299633.097107]  [<ffffffff8052cce1>] ? _spin_unlock_irqrestore+0x17/0x30
>> [4299633.097116]  [<ffffffff80240f69>] ? __mod_timer+0xd5/0xe7
>> [4299633.097129]  [<ffffffff8052b544>] schedule_timeout+0x92/0xb9
>> [4299633.097138]  [<ffffffff80240894>] ? process_timeout+0x0/0x10
>> [4299633.097146]  [<ffffffff8052b53f>] ? schedule_timeout+0x8d/0xb9
>> [4299633.097171]  [<ffffffffa00b6a47>] :iwlcore:iwl_send_cmd_sync+0x154/0x24b
>> [4299633.097183]  [<ffffffff8024ae64>] ? autoremove_wake_function+0x0/0x3d
>> [4299633.097205]  [<ffffffffa00b6b99>] :iwlcore:iwl_send_cmd+0x1b/0x1e
>> [4299633.097229]  [<ffffffffa00c454f>] :iwl4965:iwl4965_send_add_station+0x51/0xb5
>> [4299633.097259]  [<ffffffffa00ce327>] :iwl4965:iwl_remove_dynamic_key+0xf3/0x111
>> [4299633.097285]  [<ffffffffa00c1ab2>] :iwl4965:iwl4965_mac_set_key+0x123/0x139
>> [4299633.097294]  [<ffffffff8052c8f3>] ? _spin_lock+0x1b/0x33
>> [4299633.097303]  [<ffffffff802a9d8f>] ? __slab_free+0x100/0x38e
>> [4299633.097318]  [<ffffffff80513d29>] ieee80211_key_disable_hw_accel+0xd6/0x146
>> [4299633.097332]  [<ffffffff80513f39>] __ieee80211_key_todo+0x1a0/0x212
>> [4299633.097341]  [<ffffffff8045a361>] ? netdev_run_todo+0x23b/0x24a
>> [4299633.097353]  [<ffffffff80514065>] ? key_todo+0x0/0x10
>> [4299633.097362]  [<ffffffff80514057>] ieee80211_key_todo+0x1a/0x28
>> [4299633.097370]  [<ffffffff80514073>] key_todo+0xe/0x10
>> [4299633.097379]  [<ffffffff80247354>] run_workqueue+0x99/0x12b
>> [4299633.097391]  [<ffffffff802474c8>] worker_thread+0xe2/0xf3
>> [4299633.097400]  [<ffffffff8024ae64>] ? autoremove_wake_function+0x0/0x3d
>> [4299633.097410]  [<ffffffff802473e6>] ? worker_thread+0x0/0xf3
>> [4299633.097418]  [<ffffffff8024aaff>] kthread+0x4e/0x7b
>> [4299633.097428]  [<ffffffff8020cff8>] child_rip+0xa/0x12
>> [4299633.097444]  [<ffffffff8024aab1>] ? kthread+0x0/0x7b
>> [4299633.097452]  [<ffffffff8020cfee>] ? child_rip+0x0/0x12
>> [4299633.097459]
>> [4299634.116094] wlan0: RX deauthentication from 00:0f:b5:cf:6e:68 (reason=7)
>> [4299634.116094] wlan0: deauthenticated
>
> I didn't see this on 2.6.26-rc1.
> This happens everytime I reconnect my wlan, i.e. when I click on the
> essid in the gnome-applet. I attach my config and the hole dmesg output.
> My hardware is a Intel Santa Rosa Notebook with 4965agn chip.
>
What exact git tree is this?
  iwlcore:iwl_send_cmd_sync+0x154/0x24b waits for event so something
has changed in mac80211. Need to see the code.

Thanks
Tomas
