Return-Path: <linux-kernel-owner+w=401wt.eu-S1754985AbYIYVki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754985AbYIYVki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 17:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753509AbYIYVka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 17:40:30 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:5246 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYIYVk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 17:40:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Updh2GRVgDasCGsGvhrkSw2L2rbL8IOi2xkcH2iaXd/A3GOBhvDG9Smg1/nPmQzWjN
         GLxEfeAmALBWelVEWeKUEkkLWQVN5pMcPjW7Oksr1L0T07Dg181yVyAJZ+RdXqiRUi3g
         /sF/cMWNZqgv2aFPG02OHErXgirhkfxNBo6IY=
Message-ID: <f7848160809251440jfcd60f9lb962a75ff01798c8@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:40:28 -0400
From: "Parag Warudkar" <parag.lkml@gmail.com>
To: "Greg KH" <gregkh@suse.de>
Subject: Re: [patch 00/04] RFC: Staging tree (drivers/staging)
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, "Andreas Gruenbacher" <agruen@suse.de>,
       "Jeff Mahoney" <jeffm@suse.de>
In-Reply-To: <20080925205328.GB11225@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924230054.GA27730@suse.de>
	 <f7848160809241639hbe716c9q76b0e1b83d853721@mail.gmail.com>
	 <20080925020608.GA13869@suse.de>
	 <f7848160809241959s3f3092b2nf05d2245a08bed03@mail.gmail.com>
	 <20080925042108.GA3931@suse.de>
	 <f7848160809250402l163bb177oeed30f2daa18fafd@mail.gmail.com>
	 <20080925205328.GB11225@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 4:53 PM, Greg KH <gregkh@suse.de> wrote:
>
> Heh, ok, so the basic premise of getting code that is not currently in
> mergable shape into the tree earlier to get wider usage and testing is
> something that you agree with?

I don't think I got my point across - let me try again.

My disagreement was with getting crap code in mainline, re-classifying
it as something other than experimental when it is not, expecting
users to use it, printing warning when it is used, tainting the kernel
for even more harassment and then having developers not support it  as
a bonus - all cumulative. The naming part was also something that I
did not like but that like I said was just my preference and does not
matter because I disagree there is no need to TAINT  in first place.

I can imagine that getting crap code in mainline is helpful for some
class of users and developers - no problem we can have it in on that
basis - I give up my objection there.

But my objections to the other parts remain -  i.e. we should
definitely avoid the useless re-classification and TAINT, we should
change little or no other kernel code in the process of integrating
this crap, give enough deterrent for people to really think before
loading the crap code, and do not make it an official statement that
you will get no support on LKML if you load this driver. Because
certainly not all developers agree and we by definition of this
staging effort have an interest in fixing the code.

The below approach I referred few times earlier will allow us to do
exactly that - it would be good if you can tell me if this is
workable.

1) Give a staging directory for all such low quality crap
2) Give a KConfig group "Staging Drivers (Low Quality/High Risk)" and
if that is selected allow users to individually select the crappy
drivers they want to actually use - default all entries to N
3) Name all modules under staging  with a _stg suffix or something unique
4) By default do NOT load anything with a _stg suffix - deal with this
in insmod code, not the kernel
5) Require that -f be specified to load _stg modules - which will
auto-taint the kernel and developers can decide on their judgment /
situation whether or not to pursue it
 6) OOPS reports with force loaded taint and _stg in module list will
allow developers to decide whether or not to go after it

The above approach avoids re-classification/TAINTING, touches no
kernel code and does not load the crap code automatically and still
allows you to do what you intended.

Hopefully this doesn't sound like another "let us arm wrestle on what
to name it" - because it is clearly more than that!

Parag
