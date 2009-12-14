Return-Path: <linux-kernel-owner+w=401wt.eu-S933101AbZLNVaP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101AbZLNVaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:30:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755815AbZLNVaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:30:12 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34052 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758217AbZLNVaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:30:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Bkt2ZO9WGwn7ZqxYXTmLVlWDx1v4LcdLsEjXyGdxpvmhBeHEuSJrtcRRJnlDe3NUh/
         s56oTrEjigq6CCcrrdAn2MbRubyGlE4phqR8MeKMrz2GfHT/HM4JB+Cw59jKckw1+VAn
         0Xiqh5LziOk0lDDRRICFUBkXlmpK+mGUNA9Ak=
Date: Mon, 14 Dec 2009 22:30:04 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: packet_sendmsg_spkt sleeping from invalid context
Message-ID: <20091214213002.GA5203@nowhere>
References: <20091214175211.GA5102@nowhere> <4B2690E7.4030303@gmail.com> <20091214205231.GB5037@nowhere> <4B26AD65.1020004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4B26AD65.1020004@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 14, 2009 at 10:25:57PM +0100, Eric Dumazet wrote:
> Le 14/12/2009 21:52, Frederic Weisbecker a écrit :
> > 
> > I also wonder. Are you using PREEMPT_RCU ?
> 
> Not at all :)
> 
> But yes, this is illegal to do the memcpy_fromiovec() in rcu_read_lock() context.


I've just tested, and with rcu preempt it is mute, no warning :)


> > That may explain why you haven't seen this issue because
> > might_sleep() doesn't see you are in a rcu read locked
> > section as preemption is not disabled, but it is illegal to
> > voluntarily sleep in such area (although it's fine with
> > preempt rcu) as doing so with non-prempt RCU config would barf.
> > 
> > I'm trying a patch to handle that.
> 
> As you want, I also have a patch testing right now :)


But mine is to teach might_sleep() to handle rcu preempt case,
not to fix this net dev thing.

But I'll happily test the fix you have :)

Thanks.

