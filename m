Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664AbZABJiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664AbZABJiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 04:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbZABJiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 04:38:14 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750775AbZABJiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 04:38:13 -0500
Date: Fri, 2 Jan 2009 10:38:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Bryan Donlan <bdonlan@gmail.com>, Ingo Brueckl <ib@wupperonline.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: x86 (Linux Tiny): configure out support for some processors
Message-ID: <20090102093801.GD1975@elte.hu>
References: <495d2974@wupperonline.de> <3e8340490901012119i40971452q9f938702e58d7532@mail.gmail.com> <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f9a31f40901012159l255b95a8he41a341f36ebc54e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:

> On Fri, Jan 2, 2009 at 10:49 AM, Bryan Donlan <bdonlan@gmail.com> wrote:
> > On Thu, Jan 1, 2009 at 3:37 PM, Ingo Brueckl <ib@wupperonline.de> wrote:
> >> Is there any reason why CONFIG_PROCESSOR_SELECT is limited to EMBEDDED only?
> >>
> >> In my desktop pc is one specific cpu only, so I do not need support for the
> >> other processors. Unfortunately, I have no chance to disable the other ones.
> >>
> >> As it is already configurable, why not giving this option to everyone?
> >
> > EMBEDDED is just a switch to enable configuration options related to 
> > removing 'core' features of the kernel to save space. Think of it as a 
> > safety to avoid accidentally turning off something important. Feel 
> > free to switch on EMBEDDED if you want to use CONFIG_PROCESSOR_SELECT 
> > - just enabling EMBEDDED doesn't do anything by itself.
> 
> I think EMBEDDED is a misnomer for using CONFIG_PROCESSOR_SELECT and 
> should be used for more specific to Embedded stuff like for Embedded 
> range of CPUs or Embedded Systems.

i think EMBEDDED is justified in this particular case, as enabling 
CONFIG_PROCESSOR_SELECT allows you to create truly CPU-incompatible 
kernels. Kernels that panic on bootup on contemporary CPUs that happen to 
have a different manufacturer.

The normal CPU selection options (like CONFIG_MCORE2) are more like 
performance and preference hints not hard constraints - those kernels will 
generally still boot fine on most other CPUs as well. (with a few 
common-sense exceptions like booting on truly ancient CPUs, i.e. booting 
an CONFIG_MCORE2 kernel on an i486DX CPU will not work)

	Ingo
