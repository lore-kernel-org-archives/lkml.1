Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbZFKPkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbZFKPkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 11:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbZFKPjy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 11:39:54 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:52898 "EHLO
	TX2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230AbZFKPjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 11:39:53 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz1432R98dR1805M4cd6kzz1202hzzz32i6bh17ch43j)
X-FB-SS: 5,
X-WSS-ID: 0KL2ZHY-02-KM6-01
Date: Thu, 11 Jun 2009 17:38:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: Re: [PATCH 0/5 v3] x86: adapt CPU topology detection for AMD
	Magny-Cours
Message-ID: <20090611153837.GN5689@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com> <20090607134009.GE12088@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <20090607134009.GE12088@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 11 Jun 2009 15:39:29.0604 (UTC) FILETIME=[CF0FF840:01C9EAAA]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 07, 2009 at 03:40:09PM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Changes to previous patch set:
> > - remove MULTI_NODE_CPU config option
> > - provide defaults for cpu_node topology information
> > - add patch to fix AMD mcheck code
> > 
> > Current patch set contains 5 patches:
> > - patch 1 adapts common code to show cpu_node_id,
> >   cpu_node_siblings and cpu_node_siblings_list in
> >   /sys/devices/system/cpu/cpu*/topology
> > - patch 2 prepares arch/x86 to provide cpu_node information
> > - patch 3 sets up cpu_node information for AMD Magny-Cours CPU
> > - patch 4 fixes L3 cache information for Magny-Cours
> > - patch 5 fixes mcheck code for Magny-Cours
> 
> it would be really nice to propagate this info to where it _really_ 
> matters: the sched-domains topology info - unless i'm missing 
> something this patch-set does not do that yet, right?

No scheduler modifcations contained in this patch set.

> That way we'll get actual feedback if it's broken, and will help
> people if it works right. Device allocation matters too, but to a
> much lesser degree.

With and w/o this patch set scheduler is broken for Magny-Cours.

When performing

 # echo 2 >> /sys/devices/system/cpu/sched_mc_power_savings

I get (both with and without above patches):

  CPU23 attaching sched-domain:
   domain 0: span 12-23 level MC
    groups: 23 12 13 14 15 16 17 18 19 20 21 22
  ERROR: parent span is not a superset of domain->span
    domain 1: span 18-23 level CPU
  ERROR: domain->groups does not contain CPU23
     groups: 12-17 (__cpu_power = 12288)
  ERROR: groups don't span domain->span
     domain 2: span 0-23 level NODE
      groups:
  ERROR: domain->cpu_power not set

  ERROR: groups don't span domain->span

Output is from dmesg -- copied just the lines form the last CPU.

I'd appreciate if you'd pull this patch set for .31. (Maybe I have
to prepare an updated version to avoid conflicts.)

I am working on the scheduler front. But don't know when
first patches will be ready for review.


Regards,
Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


