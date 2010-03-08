Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0CHWMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 17:12:30 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:44428 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab0CHWM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 17:12:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=R2L8lb3nV/jBKcZRGeE4bxZQA+fE+bA8eUVdkBF2RcK/fMHG0oh2Dl3AJxEZJmTO0l
         223v3HAv0WSNfH+ie+Egx94VWWKPCuz+snPvt0Ek82+RASe9CEOH6SGSSl0wqopzR+eA
         ceeIKKKeAAnHfIRKiIYvTLzPmHSimcQSSM9yc=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org> 
	<20100308094647.GA14268@elte.hu> <20100308173008.7ae389ab@lxorguk.ukuu.org.uk> 
	<alpine.LFD.2.00.1003080948060.3989@localhost.localdomain>
From: Ulrich Drepper <drepper@gmail.com>
Date: Mon, 8 Mar 2010 14:12:05 -0800
Message-ID: <a36005b51003081412u536c34cbu46b5288e32c73397@mail.gmail.com>
Subject: Re: Upstream first policy
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       James Morris <jmorris@namei.org>, linux-kernel@vger.kernel.org,
       Kyle McMartin <kyle@mcmartin.ca>,
       Alexander Viro <viro@ftp.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 8, 2010 at 10:08, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> Notice how it's really fundamentally about the pathname? When you create a
> new file and overwrite /etc/passwd with that file, the security rules
> really do _not_ come from your newly created inode, they come from the
> fact that you made the path "/etc/passwd" point to that inode.

This is not a fundamental problem.  It's rather a detail of the
current policies and legacy apps.

I think I would like to see /etc/passwd to also get a file type like
/etc/shadow.  This is I think today not done because of the work
involved and the perceived lower severity because passwords are in
/etc/shadow.

So let's talk about /etc/shadow.  If somehow the file is removed and
somebody creates a new file that file won't automatically get the
right label.  This means that code reading the file then could be
prevented from doing this with appropriate policy rules.  Here the
filename is not sufficient for access.  You also need the label and
that you won't get without subverting the system.  With filename based
mechanisms this isn't the case: once the file is compromised the
attack succeeded.

Yes, the current situation isn't optimal.  We have to make the
policies more complicated and we have to get rid of restorecond (at
least for most cases).  But there is no fundamental problem with
labels while filename-based mechanisms provide no security
improvement.
