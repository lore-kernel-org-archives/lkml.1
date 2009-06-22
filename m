Return-Path: <linux-kernel-owner+w=401wt.eu-S1753413AbZFVGUR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413AbZFVGUR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 02:20:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZFVGUG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 02:20:06 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:64428 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbZFVGUE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 02:20:04 -0400
X-Greylist: delayed 47872 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 02:20:04 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uBGENBAsF2QbPmGblPpItqgxQyVdYHfsmfc98bM9vxsrfbJ5s7UuI5k0ahmvxA/45U
         ldD7h9WmpTJgC3wVU5FyBeeLfCaGEz2y5bEmmM8KdWR0ufTfqaVT0/Iv8VN2Y2mddIwz
         NJ6gMofJ1RlIn4L9htvDmeMBvNGomiGb/OjiQ=
MIME-Version: 1.0
In-Reply-To: <4A3E7F38.7030300@linux.intel.com>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <4A3E7F38.7030300@linux.intel.com>
Date: Mon, 22 Jun 2009 08:20:05 +0200
Message-ID: <8db1092f0906212320g257f0c2bme5baaec0143b706b@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, seto.hidetoshi@jp.fujitsu.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/21 Andi Kleen <ak@linux.intel.com>:

> Also a "a few minutes" suggest something might be going wrong
> with the poll handler.  Does the problem still happen
> with you use CONFIG_X86_NEW_MCE again, but before
> resume do
>
> echo 0 > /sys/device/system/machinecheck/machinecheck0/check_interval


Seems be stable.

>
> On the other hand you should get a crash very fast with
>
> echo 1 > /sys/device/system/machinecheck/machinecheck0/check_interval

System hangs during suspend to disk (not resume). It stops on this
message (no_console_suspend option enabled):
http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/img_0003.jpg

after this should be:
[ 2482.751571] CPU0 attaching NULL sched-domain.
[ 2482.752016] Switched to high resolution mode on CPU 1
[ 2482.754024] CPU0 attaching sched-domain:
[ 2482.754028]  domain 0: span 0-1 level MC
[ 2482.754032]   groups: 0 1
[ 2482.754039] CPU1 attaching sched-domain:
[ 2482.754042]  domain 0: span 0-1 level MC
[ 2482.754045]   groups: 1 0
[ 2482.755139] CPU1 is up

See:
http://unixy.pl/maciek/download/kernel/2.6.30-git17/pc/dmesg-2.6.30-git17-after-resume.txt
(dmesg after resume, but before hangs)

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
