Return-Path: <linux-kernel-owner+w=401wt.eu-S1752682AbZG3KHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbZG3KHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 06:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752477AbZG3KHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 06:07:17 -0400
Received: from smtp.witbe.net ([81.88.96.48]:58387 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbZG3KHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 06:07:16 -0400
Date: Thu, 30 Jul 2009 12:07:15 +0200
From: Paul Rolland <rol@as2917.net>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Paul Rolland <rol@as2917.net>
Subject: Re: 2.6.31-rc4 - slab entry tak_delay_info leaking ???
Message-ID: <20090730120715.65bf01ff@tux.DEF.witbe.net>
In-Reply-To: <20090729082047.048ee1a8@tux.DEF.witbe.net>
References: <20090729082047.048ee1a8@tux.DEF.witbe.net>
Organization: AS2917.net
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.2; x86_64-unknown-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 29 Jul 2009 08:20:47 +0200
Paul Rolland <rol@as2917.net> wrote:

> Hello,
> 
> Since I'm running 2.6.31-rc? (3 or 4 I think), I often find my machine
> with my X session killed in the morning, and the kdm login screen
> displayed.
> 
> This morning, I decided to save the /var/log/messages to check it before
> rebooting, and saw that the OOM killer triggered during the night.
> So, I quickly made a copy of it, and a slabtop output. There came the
> surprise : 
>   OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME
> 12899448 12899445  99%    0.11K 358318       36   1433272K
> task_delay_info       
> 
> On a freshly booted machine, the same entry shows :
>   3204   3191  99%    0.11K     89       36       356K task_delay_info
> after the X session is started.
> 
> Please find attached the slabtop -o output.

Here it starts again :( The machine is up for a little bit more that 1 day
[root@tux infocast]# uptime
 12:04:42 up 1 day,  3:53, 12 users,  load average: 0.18, 0.37, 0.48

I feel it because the machine seems to be slower when it happens, probably 
because it does have less and less memory available...

And here what the slabtop output monitoring reports :
Thu Jul 30 11:49:04 CEST 2009
task_delay_info     3292   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:50:04 CEST 2009
task_delay_info     3292   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:51:05 CEST 2009
task_delay_info     3292   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:52:05 CEST 2009
task_delay_info     3292   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:53:05 CEST 2009
task_delay_info     3292   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:54:05 CEST 2009
task_delay_info     3289   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:55:11 CEST 2009
task_delay_info     3309   3312    112   36    1 : tunables    0    0    0 : slabdata     92     92      0
Thu Jul 30 11:56:15 CEST 2009
task_delay_info    16631  16632    112   36    1 : tunables    0    0    0 : slabdata    462    462      0
Thu Jul 30 11:57:15 CEST 2009
task_delay_info    58860  58860    112   36    1 : tunables    0    0    0 : slabdata   1635   1635      0
Thu Jul 30 11:58:15 CEST 2009
task_delay_info    98422  98424    112   36    1 : tunables    0    0    0 : slabdata   2734   2734      0
Thu Jul 30 11:59:15 CEST 2009
task_delay_info   138023 138024    112   36    1 : tunables    0    0    0 : slabdata   3834   3834      0
Thu Jul 30 12:00:15 CEST 2009
task_delay_info   177587 177588    112   36    1 : tunables    0    0    0 : slabdata   4933   4933      0
Thu Jul 30 12:01:16 CEST 2009
task_delay_info   217151 217152    112   36    1 : tunables    0    0    0 : slabdata   6032   6032      0
Thu Jul 30 12:02:17 CEST 2009
task_delay_info   256715 256716    112   36    1 : tunables    0    0    0 : slabdata   7131   7131      0
Thu Jul 30 12:03:17 CEST 2009
task_delay_info   296316 296316    112   36    1 : tunables    0    0
0 : slabdata   8231   8231      0


Anyone with an idea ???
Paul

