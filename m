Return-Path: <linux-kernel-owner+w=401wt.eu-S1752276Ab0AGLUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab0AGLUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 06:20:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187Ab0AGLUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 06:20:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:43903 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0AGLUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 06:20:00 -0500
Message-ID: <4B45C35E.4080506@suse.cz>
Date: Thu, 07 Jan 2010 12:19:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: John Kacur <jkacur@redhat.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] Don't mkdir -p include/config in the sourcetree when
 	using O=outputdir option
References: <alpine.LFD.2.00.1001061705140.3744@localhost.localdomain>	 <4B44E5C8.2050006@suse.cz>	 <520f0cf11001061210w4d33fca6y98f091c4260577c0@mail.gmail.com>	 <4B44F665.6050008@suse.cz> <520f0cf11001061430l2b363d90qce43bf94a384cf13@mail.gmail.com>
In-Reply-To: <520f0cf11001061430l2b363d90qce43bf94a384cf13@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2010 23:30, John Kacur wrote:
> On Wed, Jan 6, 2010 at 9:45 PM, Michal Marek <mmarek@suse.cz> wrote:
> Michal: The length of time that a bug exists in a piece of code is no
> argument for
> it's correctness!

>From your original post I though it fails reliably for you. If it's a
race, then you're right, the time it was introduced is irrelevant :-).


> I tried to debug this using
> make -d V=1 O=/bld/2.6.33-rc3
> and discovered that the bug did not always occur, but did sometimes.
> This leads me to think that it is timing sensitive, and indeed the
> problem shows up
> more easily on a machine with multiple processors.
> 
> Is it possible that the step with mkdir -p can sometimes occur in a
> Makefile parallel process
> before the cd KBUILD_OUTPUT occurs? That would explain why it doesn't
> reliably reproduce.

OK, I still don't see how it fails, but adding $(objtree) there is a
valid change and if it fixes your problem, let's apply it.

Michal
