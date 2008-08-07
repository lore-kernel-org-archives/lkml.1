Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbYHGUyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbYHGUyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 16:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYHGUyA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 16:54:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:64796 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753199AbYHGUyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 16:54:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent:sender;
        b=bXgpmp6DES7MzDrCH2zeGejqm9yMXrtkFAWiIUVJm8pvFUYKMclVWwRo2KLOmpTrBq
         J2IkyS3ewGzw/+auE3uXVgaMMMYuiPNjPXSmtx7m7so70VHi27f8kBSyygy6xrtQEX8A
         qyCcsd+suDG5Vmyo2MfMV/YGlLC2bSBTedxEc=
Date: Fri, 8 Aug 2008 02:23:41 +0530
From: Rabin Vincent <rabin@rab.in>
To: Eric Sesterhenn <snakebyte@gmx.de>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@redhat.com
Subject: Re: Oops when accessing /proc/lockdep_chains
Message-ID: <20080807205340.GA1747@debian>
References: <20080806121650.GA3119@alice> <20080806124134.GA3615@alice>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806124134.GA3615@alice>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2008 at 02:41:34PM +0200, Eric Sesterhenn wrote:
> * Eric Sesterhenn (snakebyte@gmx.de) wrote:
> > hi,
> > 
> > with current -git (aka -rc2) i sometime get the following oops
> > when doing a cat /proc/lockdep_chains
> > The other /proc/lockdep* files dont cause any errors
> > 
> > I dont get it after a fresh reboot :| But was able to reproduce it when
> > running my testscripts, I'll try to narrow it down.
> 
> I can easily reproduce this with
> 
> modprobe rcutorture; sleep 10s; rmmod rcutorture; cat
> /proc/lockdep_chains > /dev/null

Indeed, it oopses after any module which creates a lock is unloaded.
I'll send a patch for this shortly.

Rabin
