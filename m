Return-Path: <linux-kernel-owner+w=401wt.eu-S1754239AbZDORqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239AbZDORqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 13:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324AbZDORqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 13:46:05 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:59367 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895AbZDORqC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 13:46:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=KtsJ5+0fdklXyXVdT/7Nt1P3wQKzNEdEQz1mHbntiZJLRRrS04jaERI6goAgkpH3TM
         88V7+tcAYa5bZ/yFSmvW2T+U6CbRjVHk1xMwFvTP3ER19b+rd5Cv0x1BasrlvoW+J0Cz
         +DD5qvgCfaaZT2I6OZTQjaQW0bCx9gxZioOxc=
From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.29 git master and PAT problems
Date: Wed, 15 Apr 2009 19:45:56 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc2; KDE/4.2.2; x86_64; ; )
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
References: <200903302317.04515.a.miskiewicz@gmail.com> <20090408081711.GA4938@elte.hu> <20090408223716.GC3493@linux-os.sc.intel.com>
In-Reply-To: <20090408223716.GC3493@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200904151945.56411.a.miskiewicz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 of April 2009, Pallipadi, Venkatesh wrote:
> On Wed, Apr 08, 2009 at 01:17:11AM -0700, Ingo Molnar wrote:
> > * Arkadiusz Miskiewicz <a.miskiewicz@gmail.com> wrote:
> > > On Wednesday 08 of April 2009, Pallipadi, Venkatesh wrote:
> > > > On Tue, Apr 07, 2009 at 02:12:28AM -0700, Arkadiusz Miskiewicz wrote:
> > > > > On Tuesday 07 of April 2009, Pallipadi, Venkatesh wrote:
> > > > > > On Thu, 2009-04-02 at 00:12 -0700, Arkadiusz Miskiewicz wrote:
> > > > > >
> > > > > > I was finally able to reproduce the problem of "freeing invalid
> > > > > > memtype" with upstream git kernel (commit 0221c81b1b) + latest
> > > > > > xf86 intel driver. But, with upstream + the patch I had sent you
> > > > > > earlier in this thread
> > > > > > (http://marc.info/?l=linux-kernel&m=123863345520617&w=2) I don't
> > > > > > see those freeing invalid memtype errors anymore.
> > > > > >
> > > > > > Can you please double check with current git and that patch and
> > > > > > let me know if you are still seeing the problem.
> > > > >
> > > > > Latest linus tree + that patch (it's really applied here), xserver
> > > > > 1.6, libdrm from git master, intel driver from git master,
> > > > > previously mesa 7.4 (and 7.5 snap currently), tremolous.net 1.1.0
> > > > > game (tremolous-smp binary), GM45 gpu.
> > > > >
> > > > > To reproduce I just need to run tremolous-smp and connect to some
> > > > > map. When map finishes loading I instantly get:
> > >
> > > [...]
> > >
> > > > OK. One more test patch below, applies over linus's git and you can
> > > > ignore the earlier patch. The patch below should get rid of the
> > > > problem and as it removes the track/untrack of vm_insert_pfn
> > > > completely. This will also eliminate the overhead of hundreds or
> > > > thousands of entries in pat_memtype_list. Can you please test it.
> > >
> > > With this patch I'm no longer able to reproduce problem. Thanks!
> >
> > Great, thanks!
> >
> > Venki, mind sending a patch with a proper changelog, Reported-by,
> > Tested-by tags, with Nick and Andrew Cc:-ed for the memory.c bits,
> > etc.?
>
> Ingo,
>
> Below is the cleaner version of the patch. It does not have any changes in
> mm as we are only removing the tracking inside the PAT code. I have left
> the generic mm interface as is, until we fully resolve the issue in future.
>
> Thanks,
> Venki
>
> Subject: [PATCH] x86, PAT: Remove page granularity tracking for
> vm_insert_pfn maps

I wonder what's with these patches that they missed rc2 ?

This one and Subject: [PATCH] x86, PAT: Remove duplicate memtype reserve in 
pci mmap

-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/

