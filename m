Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbYJ1Sno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbYJ1Sno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 14:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752745AbYJ1Snf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 14:43:35 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:51794 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbYJ1Sne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 14:43:34 -0400
Date: Tue, 28 Oct 2008 13:33:22 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mingo@elte.hu,
       linux-kernel@vger.kernel.org, Peter Chubb <peterc@gelato.unsw.edu.au>,
       linux-mm@kvack.org, hpa@zytor.com,
       Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk
Subject: Re: [RFC v7][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20081028183322.GA13684@us.ibm.com>
References: <48FE82DF.6030005@cs.columbia.edu> <20081022152804.GA23821@us.ibm.com> <48FF4EB2.5060206@cs.columbia.edu> <87tzayh27r.wl%peter@chubb.wattle.id.au> <49059FED.4030202@cs.columbia.edu> <1225125752.12673.79.camel@nimitz> <4905F648.4030402@cs.columbia.edu> <1225140705.5115.40.camel@enoch> <490637D8.4080404@cs.columbia.edu> <1225145373.12673.125.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1225145373.12673.125.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Mon, 2008-10-27 at 17:51 -0400, Oren Laadan wrote:
> > >       Instead, how about a flag to sys_checkpoint() -- DO_RISKY_CHECKPOINT --
> > > which checkpoints despite !may_checkpoint?
> > 
> > I also agree with Matt - so we have a quorum :)
> > 
> > so just to clarify: sys_checkpoint() is to fail (with what error ?) if the
> > deny-checkpoint test fails.
> > 
> > however, if the user is risky, she can specify CR_CHECKPOINT_RISKY to force
> > an attempt to checkpoint as is.
> 
> This sounds like an awful lot of policy to determine *inside* the
> kernel.  Everybody is going to have a different definition of risky, so
> this scheme will work for approximately 5 minutes until it gets
> patched. :)
> 
> Is it possible to enhance our interface such that users might have some
> kind of choice on these matters?

Well we could always just add a field to /proc/self/status, and let
userspace check that field (after freezing the task) for the
presence of CR_CHECKPOINT_RISKY and make up its own mind.

Though my preference is for simplicity - just refuse the checkpoint.
That way people might screan loudly enough for us to support the
features they want.  If we let them just bypass and hope for the
best that starts to dilute some of the intended effect of all this.

-serge
