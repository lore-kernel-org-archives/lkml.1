Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbXIJJ4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbXIJJ4U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 05:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbXIJJ4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 05:56:05 -0400
Received: from hu-out-0506.google.com ([72.14.214.233]:50303 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755262AbXIJJ4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 05:56:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer:mime-version:content-type:content-transfer-encoding:sender;
        b=WcNIlJfj8nIiLmGKoP/xLRqmwMudaPi3j2sEGHDc4qQaWF6sYtA16/nfHPXhq30xgAkYfbiYNcRIUaDwqHw1uXfy+LuKGMiTjQcLvFiMNMW6M4kAluLtiHO6tKeNcSSsZp+FyluMFmvCX0F+wlufEn6B9O1BMUvTnuFVF2OBtqw=
Date: Mon, 10 Sep 2007 11:55:56 +0200
From: Nicolas Capit <nicolas.capit@imag.fr>
To: Simon Derr <Simon.Derr@bull.net>
Cc: linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>
Subject: Re: cpuset trouble after hibernate
Message-ID: <20070910115556.5dd75cd7@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
References: <20070908204438.3bf03d85@localhost.localdomain>
	<Pine.LNX.4.64.0709101141180.3467@frecb006381.adech.frec.bull.fr>
X-Mailer: Claws Mail 3.0.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Sep 2007 11:45:10 +0200 (CEST)
Simon Derr <Simon.Derr@bull.net> wrote:

> On Sat, 8 Sep 2007, Nicolas Capit wrote:
> 
> > Hello,
> > 
> > This is my situation:
> >   - I mounted the pseudo cpuset filesystem into /dev/cpuset
> >   - I created a cpuset named oar with my 2 cpus
> > 
> > cat /dev/cpuset/oar/cpus 
> > 0-1
> > 
> >   - Then I hibernate my computer with 'echo -n "disk" >/sys/power/state'
> >   - After reboot:
> > 
> > cat /dev/cpuset/oar/cpus 
> > 0
> > 
> > Why did I lost a cpu?
> > Is this a normal behavior???
> 
> Hi Nicolas,
> 
> I believe this is related to the fact that hibernation uses the hotplug 
> subsystem to disable all CPUs except the boot CPU.
> 
> Thus guarantee_online_cpus() is called on each cpuset and removes all 
> CPUs, except CPU 0, from all cpusets.
> 
> I'm not quite sure about if/how this should be fixed in the kernel, 
> though. Looks like a very simple user-land workaround would be enough.
> 
> 	Simon.

Ok, it is not a big deal for me (you don't hibernate computers in a
cluster...) but I wanted to bring you this issue in case of a similar
behavior in another case...

Thanks for your response.

Nicolas Capit.
