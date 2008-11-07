Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYKGCMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYKGCMu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750903AbYKGCMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:12:41 -0500
Received: from main.gmane.org ([80.91.229.2]:38114 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920AbYKGCMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:12:41 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: kenneth johansson <ken@kenjo.org>
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
Date: Fri, 7 Nov 2008 02:12:23 +0000 (UTC)
Message-ID: <gf0867$a4d$1@ger.gmane.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	<1224484046.23068.14.camel@localhost.localdomain>
	<1225539927.2221.3.camel@localhost.localdomain>
	<1225546878.4390.3.camel@heimdal.trondhjem.org>
	<1225636847.2221.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 1-1-4-20a.ras.sth.bostream.se
User-Agent: Pan/0.132 (Waxed in Black)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 14:40:47 +0000, Ian Campbell wrote:

> On Sat, 2008-11-01 at 09:41 -0400, Trond Myklebust wrote:
>> 
>> 
>> Have you tested with the TCP RST fix yet? It has been merged into
>> mainline, so it should be in the latest 2.6.28-git, but I've attached
>> it so you can apply it to your test kernel...
> 
> I wasn't aware of it. I'll give it a go.
> 
> Thanks,
> Ian.
>>

I think I having the same problem as you. At least I have a gut feeling it's nfs related. 

What good and bad versions do you have so far in your bisecting. ??

I see the problem several times a day so it should be possible
to at least try one or two versions per day.

this is on a 2.6.27.2 client to a 2.6.26.3 server.
--------

 sudo grep blocked /var/log/syslog.0 
Nov  5 02:06:27 duo kernel: [ 5080.947067] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:08:40 duo kernel: [ 5214.091071] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:10:49 duo kernel: [ 5342.940064] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:33:15 duo kernel: [ 6688.338072] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:35:44 duo kernel: [ 6837.588072] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:38:12 duo kernel: [ 6985.765070] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 02:40:37 duo kernel: [ 7130.720067] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 06:56:00 duo kernel: [22454.090070] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 07:51:38 duo kernel: [25791.279105] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 09:39:33 duo kernel: [32267.016068] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 09:41:55 duo kernel: [32408.750061] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 09:44:17 duo kernel: [32550.484061] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 09:46:37 duo kernel: [32691.144064] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 16:26:25 duo kernel: [56678.536068] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 16:28:50 duo kernel: [56823.492067] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 16:31:17 duo kernel: [56970.594061] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 16:33:44 duo kernel: [57117.697062] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 16:51:04 duo kernel: [58158.153065] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 18:00:39 duo kernel: [62256.625050] INFO: task hald-addon-stor:7110 blocked for more than 120 seconds.
Nov  5 18:15:16 duo kernel: [63210.108080] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 18:24:08 duo kernel: [63741.610074] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 19:47:09 duo kernel: [68722.698056] INFO: task hald-addon-stor:7102 blocked for more than 120 seconds.
Nov  5 19:47:53 duo kernel: [68722.698307] INFO: task hald-addon-stor:7105 blocked for more than 120 seconds.
Nov  5 19:47:53 duo kernel: [68722.698513] INFO: task hald-addon-stor:7110 blocked for more than 120 seconds.
Nov  5 19:47:53 duo kernel: [68755.984030] INFO: task scsi_eh_12:2687 blocked for more than 120 seconds.
Nov  5 22:20:11 duo kernel: [77904.265068] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 22:23:10 duo kernel: [78083.580065] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 22:46:09 duo kernel: [79462.264081] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  5 23:22:05 duo kernel: [81599.010033] INFO: task scsi_eh_10:2675 blocked for more than 120 seconds.
Nov  5 23:22:05 duo kernel: [81599.010253] INFO: task hald-addon-stor:7097 blocked for more than 120 seconds.
Nov  5 23:22:05 duo kernel: [81599.010468] INFO: task hald-addon-stor:7102 blocked for more than 120 seconds.
Nov  5 23:22:05 duo kernel: [81599.010674] INFO: task hald-addon-stor:7110 blocked for more than 120 seconds.
Nov  6 01:46:31 duo kernel: [90209.346061] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  6 01:46:31 duo kernel: [90242.632048] INFO: task hald-addon-stor:7102 blocked for more than 120 seconds.
Nov  6 01:46:31 duo kernel: [90242.632230] INFO: task hald-addon-stor:7105 blocked for more than 120 seconds.
Nov  6 01:46:31 duo kernel: [90242.632368] INFO: task hald-addon-stor:7110 blocked for more than 120 seconds.
Nov  6 01:46:31 duo kernel: [90275.918024] INFO: task scsi_eh_12:2687 blocked for more than 120 seconds.
Nov  6 02:11:59 duo kernel: [91812.443070] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  6 02:14:12 duo kernel: [91945.587069] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  6 02:16:50 duo kernel: [92103.427069] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.
Nov  6 02:28:26 duo kernel: [92759.483053] INFO: task hald-addon-usb-:7009 blocked for more than 120 seconds.
Nov  6 02:28:26 duo kernel: [92759.483233] INFO: task hald-addon-stor:7105 blocked for more than 120 seconds.
Nov  6 02:28:26 duo kernel: [92759.483447] INFO: task hald-addon-stor:7110 blocked for more than 120 seconds.
Nov  6 02:28:26 duo kernel: [92792.769034] INFO: task scsi_eh_12:2687 blocked for more than 120 seconds.
Nov  6 02:58:49 duo kernel: [94622.425059] INFO: task cpufreq-applet:11956 blocked for more than 120 seconds.

