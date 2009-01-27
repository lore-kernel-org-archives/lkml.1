Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZA0LQs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZA0LQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 06:16:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbZA0LQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 06:16:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59422 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZA0LQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 06:16:39 -0500
Date: Tue, 27 Jan 2009 12:16:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Takashi Iwai <tiwai@suse.de>
Cc: Jean Delvare <khali@linux-fr.org>,
       Rufus & Azrael <rufus-azrael@numericable.fr>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Subject: Re: [2.6.29-rc2-git2] compilation warnings
Message-ID: <20090127111631.GB17848@elte.hu>
References: <497EB491.6080904@numericable.fr> <s5hbpttcigu.wl%tiwai@suse.de> <20090127094628.670eca16@hyperion.delvare> <s5h1vupcctf.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5h1vupcctf.wl%tiwai@suse.de>
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


* Takashi Iwai <tiwai@suse.de> wrote:

> At Tue, 27 Jan 2009 09:46:28 +0100,
> Jean Delvare wrote:
> > 
> > On Tue, 27 Jan 2009 08:32:17 +0100, Takashi Iwai wrote:
> > > At Tue, 27 Jan 2009 08:15:29 +0100,
> > > Rufus & Azrael wrote:
> > > > 
> > > > Here are my compilation warnings for fresh 2.6.29-rc2-git2 kernel :
> > > > 
> > > > > sound/pci/hda/hda_codec.c: In function ‘get_empty_pcm_device’:
> > > > > sound/pci/hda/hda_codec.c:2544: attention : ‘dev’ may be used 
> > > > > uninitialized in this function
> > > 
> > > A bogus warning.  Ignore this.
> > 
> > No matter how bogus it is, it should be fixed. Otherwise this is 
> > wasting the time of users and developers over and over again.
> 
> Well, it's a bug of gcc appearing only in a certain version, so most 
> people won't see it.
> 
> Of course, we can put uninitialized_var().  But, I don't basically like 
> adding it unconditionally...

People will again and again look at this warning and waste time deciding 
that "it's a bogus warning" or even report it. As time goes on does the 
human cost get larger, linearly.

Furthermore, if everyone in the kernel behaves like that we'll literally 
have dozens (even hundreds) of build warnings that might be bogus but 
which also obscure other, real warnings by their sheer mass.

The cost of you adding a oneliner annotation is miniscule compared to that 
and it is a one-time effort. We already spent more energy on discussing 
this than it would have taken you to annotate it. Please.

	Ingo
