Return-Path: <linux-kernel-owner+w=401wt.eu-S1758160AbYBKV04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160AbYBKV04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 16:26:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYBKV0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 16:26:49 -0500
Received: from wx-out-0506.google.com ([66.249.82.229]:44389 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075AbYBKV0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 16:26:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=c8RxeIuIPvqbTHiLDWynbP/EseLhnCV8ZJQrKDo8ZEw+vjEG6dPY0NbdYQT870B35qjJqr3827VhwPonfTsYZFCJOilJ97hlZCD4YlyxxX8NgYD3G+pNQ7aOvbwkFmB1Jd9giB7WDx2W/Ox1p7gyIBo417Kr9AYeAYzQCV/qWzQ=
Subject: Re: [PATCH 3/3] Final removal of FASTCALL()/fastcall
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>
In-Reply-To: <20080211131738.dda66683.akpm@linux-foundation.org>
References: <1202755123.6313.16.camel@brick>
	 <20080211131738.dda66683.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 13:26:44 -0800
Message-Id: <1202765204.10004.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 13:17 -0800, Andrew Morton wrote:
> On Mon, 11 Feb 2008 10:38:42 -0800
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > All users are gone, remove definitions and comments referring
> > to them.
> 
> I'm still showing occurrences in:
> 
> ./Documentation/RCU/NMI-RCU.txt
> ./Documentation/kprobes.txt
> ./Documentation/uml/UserModeLinux-HOWTO.txt
> ./kernel/rcupdate.c
> 
> The last one is interesting:
> 
> /* FASTCALL no longer exists, this wrapper may no longer be needed */
> static void wakeme_after_rcu(struct rcu_head  *head)
> {
>         struct rcu_synchronize *rcu;
> 
>         rcu = container_of(head, struct rcu_synchronize, head);
>         complete(&rcu->completion);
> }
> 
> The comment is rather ungrammatical/meaningless.  Perhaps it is trying
> to tell us that we can remove this function now?

Sorry, I added that as a note in my patch to look into and ended up
forgetting about it.

The original comment that was there read:
/* Because of FASTCALL declaration of complete, we use this wrapper */

Sorry about that, I'll look into the last occurances and send you a
patch 4/3.

Harvey

