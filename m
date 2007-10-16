Return-Path: <linux-kernel-owner+w=401wt.eu-S966003AbXJPVTt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966003AbXJPVTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:19:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965630AbXJPVTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:19:32 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:20595 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965645AbXJPVTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:19:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=emG7aP7fZCHTa6PljOh8pmNOsv+S554w3hwwaX5Gpwh77B9AzuBcm0SEENhhIQBf3Htnj2xnWUeRcJPQu9Ohuh0QU0IhPk2chHXilicSpJ+xXkVS39u509So78+oLnZY0qJBGPACGK+9IqbhFXTt373bAxKBqyJdFdWHgZAwds4=
Message-ID: <4af2d03a0710161419n3727dbfev10b1319599d30b49@mail.gmail.com>
Date: Tue, 16 Oct 2007 23:19:28 +0200
From: "Jiri Slaby" <jirislaby@gmail.com>
To: "Wagner Ferenc" <wferi@niif.hu>
Subject: Re: RocketPort Linux driver errors on module reload
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <87myujsdpr.fsf@szonett.ki.iif.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <bububu786234897832@pripojeni.net> <87k5pozgb5.fsf@tac.ki.iif.hu>
	 <4713BAD0.9020606@gmail.com> <87myujsdpr.fsf@szonett.ki.iif.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/07, Wagner Ferenc <wferi@niif.hu> wrote:
> Jiri Slaby <jirislaby@gmail.com> writes:
>
> > Anyway the driver faces another problem with pci refcounting (it
> > doesn't increment the counter) and the device might be removed from
> > it any time the pci bus code decides.
>
> That doesn't sound too good...  Do you mean the module could stop
> working any time, even if its devices are being used continuously?

Hmm, nobody holds the reference according to the current
implementation, so the pci layer doesn't know that anybody is working
with it.

> > Are you willing to test to-pci-probing patches (i.e. patches which
> > converts the driver to the model introduced in linux 2.4)?
>
> Well yes.  We've got a copule of such cards, which raises some
> interest in a proper driver.  Just send the patches with some
> instructions along, or point me to a git branch if you prefer.

Maybe the git with stand-alone module would be better...

> > If not, I'll only increment the counter on modprobe and decrement it
> > on rmmod, since it would be a safe (in the meaning of not changing
> > that much code) way of fixing the problem.
>
> And what are the drawbacks of this simple solution?

Nothing, but it's not the proper way -- just a safe fallback. But you
can still say no :).

regards,
--js
