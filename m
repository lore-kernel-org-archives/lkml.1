Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbYEMOgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbYEMOgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:36:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758027AbYEMOgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 10:36:42 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35175 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756926AbYEMOgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 10:36:41 -0400
Date: Tue, 13 May 2008 16:36:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rene Herman <rene.herman@keyaccess.nl>
Cc: Takashi Iwai <tiwai@suse.de>, Glauber Costa <gcosta@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Pete Clements <clem@clem.clem-digital.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       ALSA devel <alsa-devel@alsa-project.org>
Subject: Re: 2.6.26-rc1 regression: ISA DMA broken (bisected)
Message-ID: <20080513143619.GA1714@elte.hu>
References: <4823AAF2.7070102@keyaccess.nl> <s5hzlr0105c.wl%tiwai@suse.de> <48243D86.7020504@keyaccess.nl> <20080509122828.GB10855@elte.hu> <4824D79C.7060303@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4824D79C.7060303@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.0 required=5.9 tests=BAYES_00,WHOIS_MYPRIVREG autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	1.5 WHOIS_MYPRIVREG        URL registered to myprivateregistration.com
	[URIs: nabble.com]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rene Herman <rene.herman@keyaccess.nl> wrote:

>> great, thanks Rene for catching this! Added this line to the patch as 
>> well:
>>
>>  Tested-by: Rene Herman <rene.herman@keyaccess.nl>
>
> Oh... it was rather significantly in the AM when I posted so I forgot 
> to mention in the haste to get this out of the way but it was Pete 
> Clements who reported the regression:
>
> http://www.nabble.com/Lost-Sound-from-2.6.24-to-2.6.25----CS4236-ISA-tc17062547.html
>
> He also tested it, so as long as we're name-mention-flattering 
> around...
>
> And this a good excuse to ask how you edit changelog after the fact. 
> Just reset/reapply and stuff or is there a "better" way? I fairly 
> frequently find myself wanting to do just that but it's a bit of a 
> mess when there's already commits on top.

generally we prefer append-only repositories for public trees.

But as long as you've not pushed it out to others yet, i.e. it's a 
purely local development tree, you can use two methods:

If it's just one commit in some devel branch that you want to put into a 
'fixes' branch one you can use git-cherry-pick --edit to shuffle it 
over.

For more complex scenarios you can use git-rebase --interactive to 
rebase your commits and to edit them. Replace the command "pick" with 
"edit" to change/fix the commit message. "squash" can be used to fold 
fixes.

	Ingo
